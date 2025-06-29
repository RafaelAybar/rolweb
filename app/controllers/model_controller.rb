# Clase base para los modelos. Requiere que se implemente model_params en su hija.
class ModelController < ApplicationController
    
    include AdminAccess
    restrict_admin_access
    allow_public_access_to :index, :show
    
    def index
        @xs = @tipo.all
    end
  
    def show
        @x = @tipo.find(params[:id])
    end
  
    def new
      @x = @tipo.new
    end
  
    def create
      @x = @tipo.new(model_params)
  
      if @x.save
        redirect_to @x
      else
        Rails.logger.error "Error al crear el modelo #{@tipo.name}: #{@x.errors.full_messages.join(', ')}"
        redirect_to "/control" , alert: "Error al crear el modelo #{@tipo.name}."
      end
    end
  
    def edit
      @x = @tipo.find(params[:id])
    end
  
    def update
      @x = @tipo.find(params[:id])
  
      if @x.update(model_params)
        redirect_to @x
      else
        render :edit
      end
    end
  
    def destroy
      @x = @tipo.find(params[:id])
      @x.destroy
  
      redirect_to @tipo
    end
end
