class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :time, :action

  def time
    object.time.to_s(:rfc822)
  end

end
