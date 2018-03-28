class EventLog < Ferro::Component::Base

  MAX_LOG_LINES = 10

  def cascade
    add_child(
      :title,
      Ferro::Element::Text,
      size: 4,
      content: 'Event history'
    )

    add_child :log, Ferro::Element::List

    # Initially hidden
    add_state :hidden, true
  end

  def add_log_entry(entry)
    log.add_item(
      Ferro::Element::ListItem,
      content: entry,
      prepend: log.last_item
    )

    if log.item_count > MAX_LOG_LINES
      log.first_item.destroy
    end
  end
end