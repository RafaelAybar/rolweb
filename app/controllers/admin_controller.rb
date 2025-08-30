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
        redirect_to "/control", notice: "Caché de disco eliminada"
    end

    def delete_navbar_cache
        inner_delete_navbar_cache
        redirect_to "/control", notice: "Caché de la barra de navegación eliminada"
    end

    def delete_all_cache
        cache_clear
        redirect_to "/control", notice: "Caché de memoria eliminada"
    end
    
    def backup
    end

    def prepare_backup
    end

    def create_backup
        backup_file = nil
        begin
            backup_file = Backup.create
            data = File.binread(backup_file)

            send_data data,
                type: "application/gzip",
                disposition: "attachment",
                filename: File.basename(backup_file)
        rescue => e
            Rails.logger.error "❌ Backup failed: #{e.message} in #{e.backtrace.first}"
            Rails.logger.error e.backtrace.join("\n")
            redirect_to "/backup", alert: "Backup failed: #{e.message} in #{e.backtrace.first}"
        ensure
            if backup_file && File.exist?(backup_file)
                File.delete(backup_file)
                Rails.logger.info "🧹 Deleted temporary backup file #{backup_file}"
            else
                Rails.logger.warn "⚠️ Temporary backup file #{backup_file} does not exist or was not created."
            end
        end
    end

    def restore_backup
        if params[:backup_file].present?
            begin
                Backup.restore(params[:backup_file].tempfile.path, params[:mode]=="1")
                inner_delete_navbar_cache
                redirect_to "/backup", notice: "Backup restored successfully."
            rescue Backup::BackupRestoreRecoveredError, Backup::BackupRestoreSchemaMissmatchError => e
                Rails.logger.error "❌ Restore (#{params[:mode]=="1" ? "flexible" : "strict"}) failed: #{e.message}"
                redirect_to "/backup", alert: "Restore failed: #{e.message}"
            end
        else
            redirect_to "/backup", alert: "No backup file provided."
        end
    end

    private

    def inner_delete_navbar_cache
        cache_delete "clases_ocultas"
        cache_delete "clases_visibles"
        cache_delete "categorias"
        cache_delete "cuento_first"
    end
end

