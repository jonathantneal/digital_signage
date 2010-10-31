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
    if(current_user.try(:is_admin?))
      content_tag(:ul, :class=>'admin menu') do
        AppConfig.ui.admin_menu.map do |link_settings|
          navigation_link(link_settings.to_h.merge({:wrapper=>'li'})).to_s
        end
      end
    end
  end

  def navigation_link(settings)
  
    if settings[:controller].blank? || permitted_to?((settings[:action] || 'index').to_sym, settings[:controller].to_sym)
  
      text = settings[:text] || settings[:controller].try(:humanize)    
      url = settings[:url] || {:controller=>settings[:controller], :action=>settings[:action]}
      
      classes = []
      classes << settings[:controller] unless settings[:controller].nil?
      classes << settings[:action] unless settings[:action].nil?
      classes << settings[:css_class] unless settings[:css_class].nil?
      classes << 'active' if @controller.controller_name == settings[:controller].try(:downcase)
      class_attr_val = classes.join(' ')
      
      link = link_to(text, url, :class=>class_attr_val, :title=>text)
      
      if settings[:wrapper]
        content_tag(settings[:wrapper], link, :class=>class_attr_val)
      else
        link
      end
    
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
    link_to_function(name, h("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end

  def to_yn(bit)
    bit ? 'yes' : 'no'
  end

end
