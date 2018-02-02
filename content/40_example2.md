---
lang:     EN
page:     example2
title:    Example 2
subtitle: An event log
aside:    log
---
A second example. Here we will dynamically add and remove list elements.
You can see the list to the right (or at the bottom af the screen on a mobile device).  

This example is a log of all important events that happend since you opened this website,
like loading some content or you navigating through the application.
Try it by going back and forward a page. The event log should show two new entries.

~~~ ruby
class EventLog < FerroElementComponent

  MAX_LOG_LINES = 10

  def cascade
    add_child(
      :title,
      FerroElementText,
      size: 4,
      content: 'Event history'
    )

    add_child :log, FerroElementList
  end

  def add_log_entry(entry)
    # Add new entry to the front of the list
    log.add_item(
      FerroElementListItem,
      content: entry,
      prepend: log.last_item
    )

    if log.item_count > MAX_LOG_LINES
      log.first_item.destroy
    end
  end
end
~~~