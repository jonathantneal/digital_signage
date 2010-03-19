# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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

  # Used to automatically include a stylesheet
  def controller_stylesheet_link_tag
    if File.exists?("#{Rails.root}/public/stylesheets/#{controller.controller_name}.css")
      stylesheet_link_tag(controller.controller_name)
    end
  end

  # Used to automatically include a javascript file
  def controller_javascript_include_tag
    if File.exists?("#{Rails.root}/public/javascripts/#{controller.controller_name}.js")
      javascript_include_tag(controller.controller_name)
    end
  end

end
