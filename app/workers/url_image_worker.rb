class UrlImageWorker
  include Sidekiq::Worker

  def perform(slide, width = 1920, height = 1080)
    if slide.html_url.present?
      file = Tempfile.new(["url_preview_#{slide.id.to_s}", '.jpg'], 'tmp', :encoding => 'ascii-8bit')
      file.write(IMGKit.new(slide.html_url, width: width, height: height).to_jpg)
      file.rewind
      slide.content = file
      slide.save
      file.unlink
    end
  end
end