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
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')")
  end

  def to_yn(bit)
    bit ? 'yes' : 'no'
  end

  def action_links(object, options={}, &block)
    defaults = {
      :actions => [:show, :edit, :destroy],
      :include => [],
      :exclude => [],
      :remote => [],
      :list_wrapper => :ul,
      :list_wrapper_class => :actions,
      :link_wrapper => :li,
      :link_wrapper_class => nil
    }
    
    object_name = object.class.model_name.human
    controller_name = object.class.model_name.plural
    controller = "#{controller_name}_controller".classify.constantize.new
    
    options.reverse_merge! defaults
    options.each { |key,val| options[key] = Array(val) if defaults[key].is_a? Array }
    actions = (options[:actions] - options[:exclude]) + options[:include]
    links = []
    
    links = actions.map do |action|
      if controller.respond_to?(action) && permitted_to?(action, object)
        unless current_page?(:controller=>object.class.model_name.plural, :action=>action, :id=>object.to_param) && action != :destroy
          title = I18n.t(action, :scope=>'action_links', :default=>action.to_s.humanize)
          url = { :controller=>controller_name, :action=>action, :id=>object.id }
          html_options = { :class=>action.to_s.parameterize, :title=>"#{title} #{object_name}" }
          html_options[:remote] = true if options[:remote].include? action
          
          if action == :destroy
            html_options.merge! :method=>:delete, :confirm=>I18n.t(:confirm_delete, :scope=>'action_links', :default=>'Are you sure?')
          end
          
          link_to(title, url, html_options)
        end
      end
    end

    links << capture(&block) if block_given?

    return content_tag(options[:list_wrapper], :class=>:actions) do
      links.compact.map { |link|
        content_tag(options[:link_wrapper], link, :class=>options[:link_wrapper_class])
      }.join("\n").html_safe
    end
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

end
