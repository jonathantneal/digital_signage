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
    return 'swf' if slide.swf?
  
  end

  def slide_url(slide, version=nil)
    return nil if slide.nil?
    
    url = URI.parse(path_to_image(slide.url(version).to_s))
    if defined? request
      url.scheme = request.scheme
      url.host = request.host
      url.port = request.port
    end
    url.to_s
  end

end
