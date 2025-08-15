class InfoController < ApplicationController
    def home
        @clase_image = Clase.where("oculto IS FALSE AND image IS NOT NULL").order("RANDOM()").first.image || nil
        @habilidad_image = nil #Habilidad.where("image IS NOT NULL").order("RANDOM()").first.image || nil
        @item_image = Item.where("image IS NOT NULL").order("RANDOM()").first.image || nil
        @carousel_images = Picture.order("RANDOM()").limit(10).map(&:image)
    end
    def reglas
    end

    def estadosAlterados
        @xs = Estadoalterado.all
    end
    
    def lore
    end

    def avisolegal
    end

    def arbol
    end
end
