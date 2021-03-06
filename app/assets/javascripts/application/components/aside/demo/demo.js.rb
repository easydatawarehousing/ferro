class Demo < Ferro::Component::Base
  def cascade
    add_child(
      :title,
      Ferro::Element::Text,
      size: 4,
      content: 'Title'
    )

    add_child(
      :btn,
      DemoButton,
      content: 'Click me'
    )
  end

  def after_create
    add_state :hidden, true
  end

  def rotate_title
    txt = title.get_text
    title.set_text (txt[1..-1] + txt[0]).capitalize
  end
end

class DemoButton < Ferro::Form::Button
  def clicked
    parent.rotate_title
  end
end