class AdminsessionsController < ApplicationController
  
  def new
  end

  def create
    if params[:password] == Rails.application.credentials.admin_password
      session[:admin] = true
      redirect_to session.delete(:return_to) || root_path, notice: "Sesión iniciada"
    else
      render :new
    end
  end

  def close
    session[:admin] = nil
    redirect_to root_path, notice: "Sesión cerrada"
  end
end
