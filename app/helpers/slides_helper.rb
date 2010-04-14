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

end
