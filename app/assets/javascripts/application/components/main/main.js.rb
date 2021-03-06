class Main < Ferro::Component::Article

  DEFAULT_CONTENT = 'Loading page ...'
  CONTENT_URL     = '/ferro/main_content.json'

  def cascade
    @articles          = []
    @id                = Ferro::Sequence.new 'search_'
    @last_search_value = 'Ferro'

    add_child :title,    Ferro::Element::Text, { size: 1 }
    add_child :subtitle, Ferro::Element::Text, { size: 4 }
    add_child :content,  Ferro::Element::Text, { content: DEFAULT_CONTENT}

    add_state :hidden

    xhr_start CONTENT_URL
  end

  def xhr_start(url)
    Ferro::Xhr.new(url, method(:xhr_success), method(:xhr_error), timeout: 10000 )
  end

  def xhr_success(response)
    save_response(response)
    setup_menu
    event_log.add_log_entry "Loaded #{@articles.length} articles"
    router.navigated
  end

  def xhr_error(status, msg)
    title.set_text    ''
    subtitle.set_text ''
    content.set_text  "Error loading articles. #{msg}"
    root.menu.set_active_item(nil)
  end

  def save_response(response)
    @articles  = {}
    @root_page = nil

    response.each do |k, v|
      @articles[k] = {
        order:    v[:order],
        lang:     v[:lang],
        title:    v[:title],
        subtitle: v[:subtitle],
        aside:    v[:aside],
        content:  parse_md(v[:content])
      }

      @root_page = k if v[:root]
    end
  end

  def setup_menu
    @articles.
      sort_by { |_, v| v[:order] }.
      map { |item| item[0] }.
      each_with_index do |item, i|

      root.menu.add_item item, i == @articles.length-1
      root.header.bar.menu.add_option(item, item.capitalize)
    end
  end

  def select(pathname, search = nil)
    return if !@articles || @articles.empty?

    pagename = path_to_name(pathname)

    if !pagename && @root_page
      update_page(@root_page)

    elsif @articles.has_key?(pagename)
      update_page(pagename)

    elsif pagename == 'search'
      do_search @last_search_value

    else
      title.set_text '404'
      subtitle.set_text "Page '#{pathname}' not found"
      content.set_text ''
      root.menu.set_active_item(nil)
    end

    event_log.add_log_entry "Navigate to: #{pathname}"

    # Forget about content generated by search
    content.forget_children
  end

  def update_page(pagename)
    set_attribute('scrollTop', 0)
    title.set_text    @articles[pagename][:title]
    subtitle.set_text @articles[pagename][:subtitle]
    content.html      @articles[pagename][:content]

    update_menu(pagename)
    show_aside(@articles[pagename][:aside])
  end

  def update_menu(pagename)
    root.menu.set_active_item(pagename)
    root.header.set_prev(find_articlename_by_order( @articles[pagename][:order] - 1))
    root.header.set_next(find_articlename_by_order( @articles[pagename][:order] + 1))
    root.header.nav.share.update_state :pull_down_open, false
    root.header.bar.menu.select pagename
  end

  def show_aside(aside)
    root.aside.demo.update_state(:hidden, aside != :demo)
    root.aside.log.update_state( :hidden, aside != :log)
    root.aside.todo.update_state(:hidden, aside != :todo)
    root.aside.tictactoe.update_state(:hidden, aside != :tictactoe)
  end

  def find_articlename_by_order(order)
    a = @articles.find { |_, art| art[:order] == order }
    a ? a[0] : nil
  end

  def do_search(value)
    @last_search_value = value
    hits = count_hits(@last_search_value)

    router.replace_state('/ferro/search')
    title.set_text    'Search results'
    subtitle.set_text "Search term: '#{@last_search_value}'"
    content.html      ''
    root.menu.set_active_item(nil)
    show_aside nil

    count = 0

    hits.
      select  { |_, v| v[:total] > 0 }.
      sort_by { |_, v| -v[:total] }.
      each do |page, hit|
        count += 1

        content.add_child(
          @id.next,
          SearchHit,
          {
            title: @articles[page][:title],
            name:  page,
            hits:  hit
          }
        )
    end

    content.set_text('Nothing found') if count == 0

    event_log.add_log_entry "Searched on: '#{@last_search_value}'"
  end

  def count_hits(value)
    terms = value.downcase.split(' ').compact.uniq

    hits = {}
    @articles.each do |k, v|
      content = v[:content].downcase
      terms.each do |term|
        c = content.split(term).length - 1
        hits[k] = { total: 0 } if !hits.has_key?(k)
        hits[k][:total] += c
        hits[k][term]    = c
      end
    end

    hits
  end

  def path_to_name(pathname)
    return nil if pathname.to_s.empty? ||
                  pathname.to_s.strip == '/' ||
                  pathname.to_s.strip == '/ferro/'

    pathname.strip.downcase.sub('/ferro/', '').gsub('/', '')
  end

  def parse_md(content)
    `unescape(#{content})`
  end

  def event_log
    root.aside.log
  end

  # def xhr_post_start
  #   Ferro::Xhr.new(
  #     '/post_test',
  #     method(:xhr_post_success),
  #     method(:xhr_post_error),
  #     method: :post,
  #     body: { test: 1 }
  #   )
  # end
  # def xhr_post_success(response)
  #   puts response
  # end
  # def xhr_post_error(status, msg)
  #   puts status
  #   puts msg
  # end
end

class SearchHit < Ferro::Element::Block

  def before_create
    @title = option_replace :title
    @name  = option_replace :name
    @hits  = option_replace :hits
  end

  def cascade
    add_child(
      :title,
      Ferro::Element::Anchor,
      {
        content: @title,
        href: '/ferro/' + @name.downcase
      }
    )

    add_child(
      :content,
      Ferro::Element::Text,
      {
        content: 'Found ' + @hits.
          map { |k,v| k != :total ? "'#{k}' #{v} times": nil }.
          compact.
          join(', ')
      }
    )
  end
end