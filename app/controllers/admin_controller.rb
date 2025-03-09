class AdminController < ApplicationController
    include AdminAccess
    restrict_admin_access

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
end

