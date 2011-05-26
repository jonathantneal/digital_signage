class UserExistsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if AppConfig.security.validate_usernames
      unless BiolaWebServices.dirsvc.user_exists?(:netid=>value)
        record.errors[attribute] << 'cannot be found'
      end
    end
  end
end
