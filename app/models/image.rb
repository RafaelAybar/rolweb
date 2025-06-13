# Uso exclusivo para el SilverImageUploader

class Image < ApplicationRecord
  # atributes: nombre, data
  include ImageUrlable
end