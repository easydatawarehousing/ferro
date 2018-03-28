class Document < Ferro::Document

  def cascade
    add_child :header, Header
    add_child :menu,   Menu
    add_child :aside,  Aside
    add_child :footer, Footer
    add_child :main,   Main
    add_child :ga,     Analytics
  end

  # All navigation via main.select
  def page404(pathname)
    main.select(pathname)
  end
end

class Analytics < Ferro::Element::Script
  def load
    `document.greeter = function() { return 'Ferro says: Hello' }`
  end

  def invoke
    `console.log(document.greeter())`
  end
end