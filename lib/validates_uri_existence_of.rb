require 'net/http'
 
# Original credits: http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/
# HTTP Codes: http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTPResponse.html
 
class ActiveRecord::Base

  def self.validates_uri_existence_of(*attr_names)
  
    require 'net/http'
  
    configuration = { :message => "is not valid or not responding", :on => :save }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
 
    validates_each(attr_names, configuration) do |r, a, v|
    
      begin # check header response
      
        url = URI.parse(v)
        request = Net::HTTP.new(url.host, url.port)
        response = request.request_head(url.path.empty? ? '/' : url.path)
        
        case response
          when Net::HTTPSuccess then true
          else r.errors.add(a, configuration[:message]) and false
        end
      rescue # Recover on DNS failures..
        r.errors.add(a, configuration[:message]) and false
      end
      
    end
    
  end
  
end
