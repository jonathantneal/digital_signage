module SlidesHelper

  def slide_type(slide)
    return 'image'  if slide.image?
    return 'video'  if slide.video?
    return 'link'   if slide.link?
    return 'editor' if slide.editor?
  end

  def slide_file_url(slide, version=nil)
    require 'addressable/uri'

    return nil if slide.nil? || !slide.has_content?

    url = Addressable::URI.parse(path_to_image(slide.content_url(version).to_s))
    if defined? request
      url.scheme = request.scheme
      url.host = request.host
      url.port = request.port
    end
    url.to_s
  end

  def short_slide_url(slide)
    require 'addressable/uri'

    return nil if slide.nil?

    url = Addressable::URI.parse(path_to_image(slide.content_url.to_s))
    url.to_s
  end

end