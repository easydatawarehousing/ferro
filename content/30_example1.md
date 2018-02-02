---
lang:     EN
page:     example1
title:    Example 1
subtitle: A simple demo
aside:    demo
---

Let\'s look at a very simple example. We will define a small component
with a title and a button. The button should change the title text when clicked.  
You can see the results to the right (or at the bottom of the screen on a mobile device).
With the splitscreen icon at the top of the screen you can toggle visibility of the
example.

~~~ ruby
class Demo < FerroElementComponent
  def cascade
    # Add the title
    add_child(
      :title,
      FerroElementText,
      size: 4,
      content: 'Title'
    )

    # Add the button
    add_child(
      :btn,
      DemoButton,
      content: 'Click me'
    )
  end

  def rotate_title
    # We have access to the 'title' instance variable
    txt = title.get_text
    title.set_text (txt[1..-1] + txt[0]).capitalize
  end
end

class DemoButton < FerroFormButton
  def clicked
    # Every element knows its parent
    parent.rotate_title
  end
end
~~~

The code in Demo _cascade_ method is equivalent to something like this,
which should look more familiar to a Ruby programmer:

~~~ ruby
class Demo
  def initialize
    @title = FerroElementText.new(size: 4, content: 'Title')
    @btn   = DemoButton.new(content: 'Click me')
  end
end
~~~

Every Ferro class has 3 hooks into the object creation lifecycle:

- before_create
- after_create
- cascade

The first two are called just before and after the object itself
is created. The cascade hook is called when the object is ready
to create child objects.  
In this example most of the action happens in the _cascade_ method.

By inheriting from _FerroFormButton_, _DemoButton_ has access
to the click event handler. After a click occurred, it signals
its parent (_Demo_) to rotate the title text.

__Html ?__  
At first glance this code might look like an elaborate way to
write html. But note that there is no \'render\' method,
there is no extra work needed to interact with the two DOM elements
and we don\'t have to divide our attention over
separate html and javascript files.

In real life applications, where more logic is needed,
the ROM construction parts will blend into the background.