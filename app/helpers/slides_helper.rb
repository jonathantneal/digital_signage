module SlidesHelper

  def slide_status(slide)
    
    return 'unpublished' if slide.unpublished?
    return 'expired' if slide.expired?
    return 'hidden' if slide.hidden?
    return 'showing' if slide.showing?
    return 'unknown'
  
  end

end
