class Header < FerroElementHeader
  def cascade
    add_child :nav,   HeaderNav
    add_child :bar,   HeaderBar
    add_child :swirl, Swirl
  end

  def set_prev(name)
    bar.prev.set_text(name ? '◄ ' + name.capitalize : nil)
    bar.prev.update_href(name ? "/ferro/#{name.downcase}" : nil)
  end

  def set_next(name)
    bar.next.set_text(name ? name.capitalize + ' ►' : nil)
    bar.next.update_href(name ? "/ferro/#{name.downcase}" : nil)
  end
end

### Nav ###

class HeaderNav < FerroElementBlock
  def cascade
    add_child :back,   HeaderNavBack
    add_child :search, HeaderNavSearch
    add_child :split,  HeaderNavSplit

    add_child(
      :share,
      HeaderNavShare,
      title: '',
      items: [
        HeaderNavShareReddit,
        HeaderNavShareTwitter,
        HeaderNavShareFacebook,
      ]
    )
  end
end

class HeaderNavBack < FerroFormButton
  def clicked
    router.go_back
  end
end

class HeaderNavSearch < FerroFormSearch
  def submitted(value)
    root.main.do_search(value)
  end
end

class HeaderNavSplit < FerroFormButton
  def after_create
    @tristate = 0
    add_state :aside_hidden
    add_state :article_hidden
  end

  def clicked
    @tristate += 1

    case @tristate
    when 1
      update_state :aside_hidden,   true
      update_state :article_hidden, false
      root.aside.update_state :hidden, true
      root.main.update_state  :hidden, false
    when 2
      update_state :aside_hidden,   false
      update_state :article_hidden, true
      root.aside.update_state :hidden, false
      root.main.update_state  :hidden, true
    else
      update_state :aside_hidden,   false
      update_state :article_hidden, false
      root.aside.update_state :hidden, false
      root.main.update_state  :hidden, false
      @tristate = 0
    end
  end
end

class HeaderNavShare < FerroPullDown;end

class HeaderNavShareLink < FerroFormBlock

  def before_create
    @options[:content] = 'Share on ' + self.class.name.scan(/^HeaderNavShare(.*)$/).first.first
  end

  # https://github.com/bradvin/social-share-urls
  def open_external(url)
    ext_url = url.
      sub('{url}',      `escape('https://easydatawarehousing.github.io/ferro/')`).
      sub('{title}',    `escape('No more HTML with Opal-Ferro')`).
      sub('{via}',      'easydwh').
      sub('{hashtags}', 'ruby,ferro').
      sub('{desc}',     `escape('No more Html with the Opal-Ferro Ruby library')`)

    `window.open(#{ext_url})`
    component.nav.share.toggle_state :pull_down_open
  end
end  

class HeaderNavShareReddit < HeaderNavShareLink
  def clicked
    # https://www.reddit.com/wiki/submitting
    open_external 'https://reddit.com/submit?url={url}&title={title}'
  end
end

class HeaderNavShareTwitter < HeaderNavShareLink
  def clicked
    # https://dev.twitter.com/web/tweet-button/web-intent
    open_external 'https://twitter.com/intent/tweet?url={url}&text={title}&via={via}&hashtags={hashtags}'
  end
end

class HeaderNavShareFacebook < HeaderNavShareLink
  def clicked
    # https://stackoverflow.com/questions/20956229/has-facebook-sharer-php-changed-to-no-longer-accept-detailed-parameters
    open_external 'https://www.facebook.com/sharer.php?u={url}&title={title}&description={desc}'
  end
end

### Header ###

class HeaderBar < FerroElementBlock
  def cascade
    add_child :logo,  HeaderLogo
    add_child :prev,  HeaderPrev
    add_child :next,  HeaderNext
    add_child :menu,  DropdownMenu
  end
end

class HeaderLogo < FerroFormButton
  def after_create
    add_state :rotate
  end

  def clicked
    toggle_state :rotate
  end
end

# Define classes so we can add some styling
class HeaderPrev < FerroElementAnchor;end
class HeaderNext < FerroElementAnchor;end

class DropdownMenu < FerroFormSelect
  def changed
    router.go_to('/ferro/' + selection[:option])
  end
end

### Swirl ###

class Swirl < FerroElementBlock
  def cascade
    add_child :swirl, SwirlCanvas
  end  
end

class SwirlCanvas < FerroElementCanvas

  # var g = c.createLinearGradient(0,0, 0,h);
  # g.addColorStop(0, "#fece3e");
  # g.addColorStop(1, "#ececec");
  # c.fillStyle = g;

  def after_create
    %x{
      var c = #{element}.getContext("2d");
      var w = #{element}.width;
      var h = #{element}.height;
      c.beginPath();
      c.moveTo(0,0);
      c.bezierCurveTo(w*0.25,h, w*0.75,0, w,h);
      c.lineTo(w,0);
      c.lineTo(0,0);
      c.fillStyle = "#fece3e";
      c.fill(); 
    }
  end
end