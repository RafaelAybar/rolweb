class InfoController < ApplicationController
    def home
        @clase_image = Clase.where("oculto IS FALSE AND image IS NOT NULL").order("RANDOM()").first.image || nil
        @habilidad_image = nil #Habilidad.where("image IS NOT NULL").order("RANDOM()").first.image || nil
        @item_image = Item.where("image IS NOT NULL").order("RANDOM()").first.image || nil
        @carousel_images = Picture.order("RANDOM()").limit(10).map(&:image)
    end

    def get_random_element
        model = [Clase, Habilidad, Item].sample
        element = model.order("RANDOM()").first
        render partial: element, locals: {
            Clase    => { clase: element },
            Habilidad => { habil: element },
            Item     => { item: element }
        }[model]
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
