module ApplicationHelper
  def importJS (module_name)
    content_for :head do
      javascript_import_module_tag(module_name)
    end
  end
end
