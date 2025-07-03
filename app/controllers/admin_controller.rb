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
        DiskCache.clear_disk_cache!
        redirect_to "/control"
    end

    def delete_navbar_cache
        cache_delete "clases_ocultas"
        cache_delete "clases_visibles"
        cache_delete "categorias"
        redirect_to "/control"
    end
    
    def backup
    end


    def create_backup
        begin
            backup_file = Backup.create
            data = File.binread(backup_file)

            send_data data,
                type: "application/gzip",
                disposition: "attachment",
                filename: File.basename(backup_file),
                stream: false
        rescue => e
            Rails.logger.error "Backup failed: #{e.message} in #{e.backtrace.first}"
            Rails.logger.error e.backtrace.join("\n")
            redirect_to "/backup", alert: "Backup failed: #{e.message} in #{e.backtrace.first}"
          ensure
            File.delete(backup_file)
            Rails.logger.info "🧹 Deleted temporary backup file #{backup_file}"
        end
    end

    def restore_backup
        if params[:backup_file].present?
            begin
                Backup.restore(params[:backup_file].tempfile.path)
                redirect_to "/backup", notice: "Backup restored successfully."
            rescue => e
                Rails.logger.error "Restore failed: #{e.message} in #{e.backtrace.first}"
                redirect_to "/backup", alert: "Restore failed: #{e.message} in #{e.backtrace.first}"
            end
        else
            redirect_to "/backup", alert: "No backup file provided."
        end
    end
end

