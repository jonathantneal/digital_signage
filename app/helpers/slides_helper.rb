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

  def publish_status_icon(status, is_active_status)
    text = is_active_status ? status.titleize : nil
    case status
    when 'published'
      fa_icon 'check-circle-o', text: text
    when 'unpublished'
      fa_icon 'circle-o', text: text
    when 'expired'
      fa_icon 'exclamation-circle', text: text
    end
  end

  def publish_status_filters
    Slide::PUBLISHED_STATUS.map do |status|
      classes = ['btn', 'btn-default', 'bs-tooltip']
      new_status = status

      if is_active_status = (params[:published_status] == status)
        classes.push('active')
        new_status = nil
      end

      link_to publish_status_icon(status, is_active_status), params.merge({published_status: new_status}), class: classes.join(' '), title: status.titleize, 'data-placement'=>'bottom'
    end.join(' ')
  end

end