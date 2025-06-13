module ImageUrlable
  extend ActiveSupport::Concern
  
  def url
    Rails.application.routes.url_helpers.download_image_path(id)
  end
end
