class AdminController < ApplicationController
    include AdminAccess
    restrict_admin_access

    include UnlimitedCache
    
    def control
    end

    def habilidads_ocultas
        redirect_to habilidads_path(mode: "hidden")
    end

    def habilidads_sueltas
        redirect_to habilidads_path(mode: "sueltas")
    end

    def items_no_categ
    end

    def delete_disk_cache
        HybridCache.clear_disk_cache!
        redirect_to "/control"
    end

    def delete_navbar_cache
        cache_delete "clases_ocultas"
        cache_delete "clases_visibles"
        cache_delete "categorias"
        redirect_to "/control"
    end

    def delete_all_cache
        cache_clear
        redirect_to "/control"
    end
end

