module SlidesHelper

  def slide_status(slide)
    return 'unpublished' if slide.unpublished?
    return 'expired' if slide.expired?
    return 'hidden' if slide.hidden?
    return 'showing' if slide.showing?
    return 'unknown'
  end

  def slide_type(slide)
    return 'image' if slide.image?
    return 'video' if slide.video?
    return 'embed'
  end

  def slide_file_url(slide, version=nil)
    require 'addressable/uri'

    return nil if slide.nil?

    url = Addressable::URI.parse(path_to_image(slide.url(version).to_s))
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

    url = Addressable::URI.parse(path_to_image(slide.url.to_s))
    url.to_s
  end

end