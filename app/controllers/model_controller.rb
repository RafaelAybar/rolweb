# Clase base para los modelos. Requiere que se implemente model_params en su hija.
class ModelController < ApplicationController

    before_action :set, only: %i[show edit update destroy]
    
    include AdminAccess
    restrict_admin_access
    allow_public_access_to :index, :show

    def set
      @x = @tipo.find(params[:id])
    end
    
    def index
        @xs = @tipo.all
    end
  
    def show
    end
  
    def new
      @x = @tipo.new
    end
  
    def create
      @x = @tipo.new(model_params)
  
      if @x.save
        redirect_to @x
      else
        redirect_to "/control" , notice: 'La jodiste.'
      end
    end
  
    def edit
    end
  
    def update
      if @x.update(model_params)
        redirect_to @x
      else
        render :edit
      end
    end
  
    def destroy
      @x.destroy
  
      redirect_to @tipo
    end
end
