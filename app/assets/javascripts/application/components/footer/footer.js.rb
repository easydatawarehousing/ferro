# For the ruby version of date handling use:
#   require 'date'
#   Date.today.year
#
# But this adds ~11Kb to the final .js file

class Footer < Ferro::Component::Footer
  def cascade
    add_child(
      :copyright,
      Ferro::Element::Text,
      content: "Copyright 2017-#{`(new Date()).getFullYear()`} | Ivo Herweijer |"
    )

    add_child(
      :opalferro,
      Ferro::Element::ExternalLink,
      content: 'Opal-Ferro',
      href: 'https://github.com/easydatawarehousing/opal-ferro'
    )

    add_child(
      :spacer,
      Ferro::Element::Text,
      content: '|'
    )

    add_child(
      :ferro,
      Ferro::Element::ExternalLink,
      content: 'Website source',
      href: 'https://github.com/easydatawarehousing/ferro'
    )
  end
end