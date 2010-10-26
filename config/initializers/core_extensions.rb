class Time

  def same_day?(other_time)
  
    unless other_time.respond_to?(:to_date)
      raise(ArgumentError, "Argument can't be converted to a date")
    end
      
    self.to_date == other_time.to_date
     
  end

end
