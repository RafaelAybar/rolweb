module Utilities
  extend ActiveSupport::Concern

  def error_coalesce 
    begin
      yield || nil
    rescue
      nil
    end
  end
end