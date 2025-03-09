class Image < ApplicationRecord
  # atributes: nombre, data
  include Rails.application.routes.url_helpers
  
  def url
    self.id ? download_image_path(self.id) : nil
  end
end
