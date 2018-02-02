class FileContent

  attr_reader :page

  def initialize(source_file, order)
    @source_file = source_file
    @order       = order
    @lang        = nil
    @page        = nil
    @root        = false
    @title       = nil
    @subtitle    = nil
    @aside       = nil
    @content     = nil
    read_parse_file
    puts "Parsed: #{source_file.to_s}"
  end

  def read_parse_file
    dashline_count = 0
    text = []

    IO.readlines(@source_file).each do |line|
      if dashline_count < 2
        line.match('---') { |m|
          dashline_count += 1
        }

        line.match(/^lang:\s+(.*)/) { |m|
          @lang = m[1].strip
        }

        line.match(/^page:\s+(.*)/) { |m|
          @page = m[1].strip
        }

        line.match(/^root:\s+(.*)/) { |m|
          @root = m[1].strip == 'true'
        }

        line.match(/^title:\s+(.*)/) { |m|
          @title = m[1].strip
        }

        line.match(/^subtitle:\s+(.*)/) { |m|
          @subtitle = m[1].strip
        }

        line.match(/^aside:\s+(.*)/) { |m|
        @aside = m[1].strip
      }
      else
        text << line if text.present? || line.present?
      end
    end

    @content = text.join('')
  end

  def to_hash
    {
      order:    @order,
      lang:     @lang,
      root:     @root,
      title:    @title,
      subtitle: @subtitle,
      aside:    @aside,
      content:  URI.escape(
        Kramdown::Document.new(@content, { coderay_line_numbers: nil }).to_html
      )
    }
  end
end

class ContentCollector

  def initialize(source_path, target_filename, force_collect = true)
    @source_path     = source_path
    @target_filename = target_filename
    @force_collect   = force_collect

    setup_source_files

    collect_sources if source_is_newer?
  end

  def pagelist
    @collection.map { |c| c.page }
  end

  private

  def setup_source_files
    @source_files = Dir.entries(@source_path).
      select  { |f| !['.', '..'].include?(f) }.
      sort_by { |f| f.scan(/\A([\d]*)_/).first.first.to_i }.
      map     { |f| @source_path.join(f) }
  end

  def source_is_newer?
    return false if @source_files.blank?

    return true if @force_collect || !File.exists?(@target_filename)

    target_time = File.mtime(@target_filename)

    @source_files.any? do |f|
      File.mtime(f) > target_time
    end
  end

  def collect_sources
    @collection = []
    @source_files.each_with_index do |f, i|
      @collection << FileContent.new(f, i + 1)
    end

    content = {}
    @collection.each do |f|
      content[f.page] = f.to_hash
    end

    File.open(@target_filename, 'w') do |f|
      f.write content.to_json.to_s
    end
  end
end