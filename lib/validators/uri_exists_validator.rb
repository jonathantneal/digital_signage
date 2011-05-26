# Original credits: http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/
# HTTP Codes: http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTPResponse.html
require 'net/http'

class UriExistsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin # check header response    
      url = URI.parse(value)
      request = Net::HTTP.new(url.host, url.port)
      response = request.request_head(url.path.empty? ? '/' : url.path)
      unless response.is_a? Net::HTTPSuccess
        record.errors[attribute] << 'is not valid or not reponding'
      end
    rescue # Recover on DNS failures..
      record.errors[attribute] << 'is not valid or not reponding'
    end
  end
end
