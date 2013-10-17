# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def all_messages
    type_to_class = { notice: :info, alert: :danger, error: :danger }

    # Standard flash messages
    messages = flash.map do |type, msg|
      { type: type, message: msg, class: (type_to_class[type] || type) }
    end

    # Model validation errors
    model = instance_variable_get("@#{controller_name.singularize}")
    unless model.nil?
      if model.respond_to? :errors
        messages += model.errors.full_messages.map do |msg|
          { type: :error, message: msg, class: :danger}
        end
      end
    end

    messages
  end

  # Taken from http://blog.perplexedlabs.com/2008/02/08/seconds-to-minutesseconds-in-rails/
  def seconds_to_time(seconds)
    total_minutes = seconds / 1.minutes
    seconds_in_last_minute = seconds - total_minutes.minutes.seconds
    "#{total_minutes}m #{seconds_in_last_minute}s"
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :class=>'add_fields btn btn-default')
  end

  def to_yn(bit)
    bit ? 'yes' : 'no'
  end

  def page_entries_info(collection, options = {})
    entry_name = options[:entry_name] ||
      (collection.empty?? 'entry' : collection.first.class.name.underscore.sub('_', ' '))

    if collection.num_pages < 2
      case collection.total_count
      when 0; "No #{entry_name.pluralize} found"
      when 1; "<strong>1</strong> #{entry_name}"
      else;   "<strong>All #{collection.size}</strong> #{entry_name.pluralize}"
      end
    else
      %{<strong>%d - %d</strong> of <strong>%d</strong> #{entry_name.pluralize}} % [
        collection.offset_value + 1,
        collection.offset_value + collection.length,
        collection.total_count
      ]
    end.html_safe
  end

  def cancel_button
    link_to 'Cancel', :back, :class => "btn"
  end

  # This is useful for carrierwave files which are only returned as relative urls
  def absolute_url(url)
    request.protocol + request.host_with_port + url
  end

end
