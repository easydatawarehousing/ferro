---
lang:     EN
page:     example3
title:    Example 3
subtitle: A simple Todo list
aside:    todo
---

Every new technology seems to need a __todo__ application to show of its usefulness.
So lets not disappoint anyone and make our own version. You can see the result to the
right (or at the bottom af the screen on a mobile device).  

Even a simple todo app has more moving parts than you might at first think.
Functionally we need the following elements:

- a container to keep the entire todolist
- a title to show that it is indeed a todo list
- a text input and button to add new todo items
- a status bar showing how many (open) items there are, plus a link to remove completed items
- a list of todo items
- the actual todo items, showing a description and a checkbox to mark the item as completed

Now we translate these functional elements into a Master Object Model.
Note that the code listed below is the actual code running the sample application.
And apart from some CSS rules it is everything we need.

__The todo component__  
This defines all the needed parts (except todo items) and defines some helper methods.

~~~ ruby
class Todo < Ferro::Component::Base
  def cascade
    add_child :title,  Ferro::Element::Text, size: 4, content: 'Todo list'
    add_child :entry,  TodoEntry, button_text: 'Add', placeholder: 'New item ...'
    add_child :status, TodoStatus
    add_child :list,   TodoList

    update_status
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
~~~

__Text input and button__  
This is easy since we can use a ready made Ferro component. The same
component is used in the search function at the top the screen.

~~~ ruby
class TodoEntry < Ferro::Combo::Search
  def submitted(value)
    parent.add_list_item value
  end
end
~~~

__Status bar__  
Just a text to show a count of items and a \'clear\' link.

~~~ ruby
class TodoStatus < Ferro::Element::Block
  def cascade
    add_child :info,  Ferro::Element::Text
    add_child :clear, TodoStatusClear, content: '[clear]', href: ''
  end

  def update_status
    info.set_text "#{parent.list.open_items} of #{parent.list.total_items} remaining"
  end
end

class TodoStatusClear < Ferro::Element::Anchor
  def clicked
    # We could use: parent.parent.clear_list

    # Here we use the top-down way to access the same method.
    # 'component' points to the nearest element in the
    # hierarchy that is a Ferro component.
    # In this case this the Todo instance.
    component.clear_list
  end
end
~~~

__List of todo items__  
The list to hold and manage the todo items. It adds 3 default items.

~~~ ruby
class TodoList < Ferro::Form::Base
  def cascade
    @list = []
    @id   = Ferro::Sequence.new 'item_'

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
~~~

__Todo item__  
A checkbox with a label.

~~~ ruby
class TodoItem < Ferro::Element::Block
  def before_create
    @content = option_replace :content
  end

  def cascade
    add_child :cb,      TodoCheckBox
    add_child :content, TodoLabel, content: @content, for: cb.object_id
  end

  def toggle_content(completed)
    content.update_state(:completed, completed)
    component.update_status
  end

  def checked?
    cb.checked?
  end
end

class TodoCheckBox < Ferro::Form::CheckBox
  def clicked
    parent.toggle_content checked?
  end
end

class TodoLabel < Ferro::Form::Label
  def after_create
    add_state :completed
  end
end
~~~

Here we see the _add\_state_ and _update\_state_ methods being
used for the first time. A state is a boolean flag that you
can add to any Ferro class. If it has a true state Ferro will add
a CSS class with the same name to the DOM element.
In this case there is a CSS rule for the strike-through effect:

~~~ css
.completed {
  text-decoration: line-through;
}
~~~
