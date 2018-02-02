class Menu < FerroElementNavigation

  def cascade
    add_child :items, FerroElementBlock
  end

  def set_active_item(item_name)
    items.children.each do |name, item|
      item.update_state(:menu_item_selected, name == item_name)
      item.update_state(:menu_item_visited,  name == item_name ? true : nil)
    end
  end

  def add_item(name, last)
    items.add_child(symbolize(name), MenuItem, { name: name })

    if !last
      items.add_child "spacer_#{symbolize(name)}", FerroElementBlock, { class: 'menu-spacer' }
    end
  end
end

class MenuItem < FerroElementBlock

  def after_create
    add_states [:menu_item_selected, :menu_item_visited]
  end

  def cascade
    add_child :img, FerroElementBlock, { class: 'menu-image' }

    add_child(
      :link,
      FerroElementAnchor,
      {
        content: @options[:name].capitalize,
        href: '/' + @options[:name].downcase
      }
    )
  end
end