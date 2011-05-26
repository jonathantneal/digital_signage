class String

  # Integer() raises an exception, to_i() returns 0, this returns nil
  def try_to_i
    Integer(self) rescue nil
  end

  # Float() raises an exception, to_f() returns 0, this returns nil
  def try_to_f
    Float(self) rescue nil
  end

  def to_range(separator='-')
  
    parts = self.split(separator).map do |part|
      block_given? ? yield(part) : part.strip
    end.compact
    
    parts += parts if parts.length == 1
    
    Range.new(*parts) if parts.length == 2
    
  end

  def wrap(wrapper)
    wrapper+self+wrapper
  end

  def lchomp(match)
    if index(match) == 0
      self[match.size..-1]
    else
      self.dup
    end
  end  

  def lchomp!(match)
    if index(match) == 0
      self[0...match.size] = ''
      self
    end
  end

  def trim(match)
    self.lchomp(match).chomp(match)
  end
  
  def trim!(match)
    self.lchomp!(match)
    self.chomp!(match)
  end

  # Taken from http://snippets.dzone.com/posts/show/4578
  def smart_truncate(length, end_string='...')
    if self.length >= length
      shortened = self[0, length]
      splitted = shortened.split(/\s/)
      words = splitted.length
      splitted[0, words-1].join(" ") + end_string
    else
      self
    end
  end

end

class OpenStruct

  # Recursively converts ClosedStructs to hashes
  def deep_to_h

    to_hash = lambda do |val|
      if val.respond_to?(:to_h)
        val = val.to_h.inject({}) do |hash, (k,v)|
          hash[k] = to_hash.call(v)
          hash
        end
      elsif val.respond_to?(:inject) && !val.is_a?(String)
        val = val.inject([]) do |arr, item|
          arr << to_hash.call(item)
          arr
        end
      end
      val
    end 

    to_hash.call(self)
  
  end

end

class Hash

  def to_html
  
    to_tag = lambda do |val|
      html = ''
      if val.is_a?(Hash)
        html += "<dl>\n"
        val.each do |k,v|
          html += "  <dt>#{CGI.escapeHTML(k.to_s)}</dt>\n"
          html += "  <dd>"+to_tag.call(v)+"</dd>\n"
        end
        html += "</dl>\n"
      elsif val.is_a?(Array)
        html += "<ul>\n"
        val.each do |item|
          html += "  <li>"+to_tag.call(item)+"</li>\n"
        end
        html += "</ul>\n"
      else
        html += CGI.escapeHTML(val.to_s)
      end
      html
    end 

    to_tag.call(self).html_safe
  
  end

end

class Time

  def same_day?(other_time)
  
    unless other_time.respond_to?(:to_date)
      raise(ArgumentError, "Argument can't be converted to a date")
    end
      
    self.to_date == other_time.to_date
     
  end

end
