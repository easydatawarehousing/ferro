# Use:
#   require 'date'
#   Date.today.year
# for the ruby version of date handling
# This adds ~11Kb to the final .js application that we don't need

class Footer < FerroElementFooter
  def cascade
    add_child(
      :copyright,
      FerroElementText,
      content: "Copyright 2017-#{`(new Date()).getFullYear()`} | Ivo Herweijer |"
    )

    add_child(
      :opalferro,
      FerroElementExternalLink,
      content: 'Opal-Ferro',
      href: 'https://github.com/easydatawarehousing/opal-ferro'
    )

    add_child(
      :spacer,
      FerroElementText,
      content: '|'
    )

    add_child(
      :ferro,
      FerroElementExternalLink,
      content: 'Website source',
      href: 'https://github.com/easydatawarehousing/ferro'
    )
  end
end