class Image < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  def url
    download_image_path(self.id)
  end
end
