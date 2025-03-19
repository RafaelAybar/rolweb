module AdminAccess
  extend ActiveSupport::Concern

  def require_admin
    unless session[:admin]
      session[:return_to] = request.fullpath
      redirect_to new_adminsession_path
    end
  end

  class_methods do
    def restrict_admin_access
      before_action :require_admin
    end

    def allow_public_access_to(*actions)
      skip_before_action :require_admin, only: actions
    end

    def restrict_admin_access_to(*actions)
      before_action :require_admin, only: actions
    end
  end

end
