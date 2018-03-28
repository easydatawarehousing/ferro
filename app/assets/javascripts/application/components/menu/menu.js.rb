class Menu < Ferro::Component::Navigation

  def cascade
    add_child :items, Ferro::Element::Block
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
      items.add_child "spacer_#{symbolize(name)}", Ferro::Element::Block, { class: 'menu-spacer' }
    end
  end
end

class MenuItem < Ferro::Element::Block

  def after_create
    add_states [:menu_item_selected, :menu_item_visited]
  end

  def cascade
    add_child :img, Ferro::Element::Block, { class: 'menu-image' }

    add_child(
      :link,
      Ferro::Element::Anchor,
      {
        content: @options[:name].capitalize,
        href: '/ferro/' + @options[:name].downcase
      }
    )
  end
end