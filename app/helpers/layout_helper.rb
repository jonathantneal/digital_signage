module LayoutHelper

  # Used to automatically include a stylesheet
  def controller_stylesheet_link_tag(args={})
    if File.exists?("#{Rails.root}/public/stylesheets/#{controller.controller_name}.css")
      stylesheet_link_tag(controller.controller_name, args)
    end
  end

  # Used to automatically include a javascript file
  def controller_javascript_include_tag
    if File.exists?("#{Rails.root}/public/javascripts/#{controller.controller_name}.js")
      javascript_include_tag(controller.controller_name)
    end
  end

  def yield_or_default(name, &block)
    name = name.kind_of?(Symbol) ? ":#{name}" : name
    out = eval("yield #{name}", block.binding)
    concat(out || capture(&block), block.binding)
  end

  def google_analytics_script_tag
    
    config = AppConfig.google_analytics
    
    if config.enabled
    
      <<-eos
        <script type="text/javascript">

          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', '#{config.web_property_id}']);
          _gaq.push(['_trackPageview']);

          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();

        </script>
      eos
    
    end
    
  end

end
