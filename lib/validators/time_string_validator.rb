class TimeStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    require 'chronic'
    record.errors[attribute] << "doesn't seem to be a valid time" unless Chronic.parse(value)
  end
end
