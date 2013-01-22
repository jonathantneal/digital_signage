class SlideSerializer < ActiveModel::Serializer
  attributes :id, :title, :delay, :color, :uri, :lastupdate, :showing
  attribute :type, key: :content_type

  def color
    '#' + object.color
  end
  def uri
    object.url
  end
  def lastupdate
    (object.updated_at || object.created_at).to_s(:rfc822)
  end

  def showing
    object.showing?
  end

end
