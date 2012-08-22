# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def all_messages
  
    # Standard flash messages
    messages = flash.map{|key,val| {:type=>key, :message=>val} }
    
    # Model validation errors
    model = instance_variable_get("@#{controller_name.singularize}")
    unless model.nil?
      messages += model.errors.full_messages.map do |msg|
        {:type=>:error, :message=>msg}
      end
    end
    
    messages
    
  end

  def admin_menu
    if(current_user.try(:is_admin?) || current_user.try(:is_developer?))
      content_tag(:ul, :class=>'admin menu') do
        AppConfig.ui.admin_menu.map do |link_settings|
          navigation_link(link_settings.to_h.merge({:wrapper=>'li'})).to_s
        end.join("\n").html_safe
      end
    end
  end

  def navigation_link(settings)

    # Get settings and set defaults
    action = (settings[:action] || :index).to_sym
    controller = settings[:controller]
    controller = "/#{controller}" unless controller.blank? || controller.to_s[0] == ?/
    controller_sym = controller.try(:parameterize,'_').try(:to_sym) 
    controller_name = controller.try(:split,'/').try(:last).try(:downcase)
    url =  settings[:url] || {:controller=>controller, :action=>action}
    text = settings[:text] || controller_name.try(:humanize) 
    css_class = settings[:css_class]
    wrapper = settings[:wrapper]
  
    # Check permissions
    if controller.blank? || permitted_to?(action, controller_sym)
      
      # HTML element classes
      classes = [controller_name, action, css_class]
      classes << 'active' if self.controller.controller_name == controller_name
      class_attr_val = classes.join(' ')
      
      # Link tag
      link = link_to(text, url, :class=>class_attr_val, :title=>text)
      
      # Optional wrapper
      wrapper ? content_tag(wrapper, link, :class=>class_attr_val) : link
    
    end
    
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
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :class=>:add_fields)
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
    link_to 'Cancel', :back, :class => "cancel button"
  end

end
