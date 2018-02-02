class Todo < FerroElementComponent

  def cascade
    add_child :title,  FerroElementText, size: 4, content: 'Todo list'
    add_child :entry,  TodoEntry,        button_text: 'Add', placeholder: 'New item ...'
    add_child :status, TodoStatus
    add_child :list,   TodoList

    update_status

    add_state :hidden, true
  end

  def update_status
    status.update_status
  end

  def add_list_item(value)
    list.add_item value
    update_status
  end

  def clear_list
    list.clear
  end
end

### TodoEntry ###

class TodoEntry < FerroFormSearch

  def submitted(value)
    parent.add_list_item value
  end
end

### TodoStatus ###

class TodoStatus < FerroElementBlock

  def cascade
    add_child :info,  FerroElementText
    add_child :clear, TodoStatusClear, content: '[clear]', href: ''
  end

  def update_status
    info.set_text "#{parent.list.open_items} of #{parent.list.total_items} remaining"
  end
end

class TodoStatusClear < FerroElementAnchor

  def clicked
    component.clear_list
  end
end

### TodoList ###

class TodoList < FerroForm

  def cascade
    @list = []
    @id   = FerroSequence.new 'item_'

    [
      'Learn Ruby',
      'Learn Ferro',
      'Create first NoHTML website',
    ].each do |name|
      add_item(name)
    end
  end

  def add_item(name)
    label = name.strip

    if !label.empty?
      @list << add_child(@id.next, TodoItem, content: label)
    end
  end

  def clear
    @list.delete_if do |item|
      item.destroy if item.checked?
    end

    parent.update_status
  end

  def open_items
    @list.select { |item| !item.checked? }.length
  end

  def total_items
    @list.length
  end
end

class TodoItem < FerroElementBlock

  def before_create
    @content = option_replace :content
  end

  def cascade
    add_child :cb,      TodoCheckBox, type: :checkbox
    add_child :content, TodoLabel,    content: @content, for: cb.object_id
  end

  def toggle_content(completed)
    content.update_state(:completed, completed)
    component.update_status
  end

  def checked?
    cb.checked?
  end
end

class TodoCheckBox < FerroFormCheckBox

  def clicked
    parent.toggle_content checked?
  end
end

class TodoLabel < FerroFormLabel

  def after_create
    add_state :completed
  end
end