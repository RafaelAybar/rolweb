[También tienes este README en inglés Spanish](README.md).
# README (Español)  

Esta aplicación puede ejecutarse como un par de contenedores de Docker (modo desarrollo) o como una aplicación normal de Ruby on Rails (modo producción).  

## Modo Desarrollo  

Para ejecutarla en Docker, sigue estos pasos:  

1. Instala Docker (:p).  

2. Crea las carpetas vacías necesarias para la base de datos. Para ello, puedes ejecutar `crear_dirs_for_db_data.sh`; o, si no puedes ejecutarlo, simplemente créalas manualmente. Algunas ya pueden existir, tan solo asegúrate de que las siguientes carpetas existen dentro de `/db_data/`:  
    ```  
    "pg_commit_ts"
    "pg_logical/pg_logical"
    "pg_logical/snapshots"
    "pg_logical/mappings"
    "pg_notify"
    "pg_replslot"
    "pg_snapshots"
    "pg_tblspc"
    "pg_twophase"
    ```  
3. Ejecuta ```sh docker compose up```  en la carpeta raíz:  

4. Puedes acceder a la web en `localhost:80`. También puedes acceder a la base de datos en el puerto `5555`.  

Existe un sistema de admin dentro de la página web para modificar los datos. Debes de establecer `admin_password` en los credenciales de rails para poder acceder a él.

Encontrarás un montón de contenido que estaba guardado en la base de datos.

Los datos de la base de datos se guardan en Git para tenerlos siempre disponibles con fines de prueba durante el desarrollo.  

## Modo Producción de Docker
Puedes ejecutar esta applicación en modo de producción simplemente cambiando la confiugración en el archivo `.env` antes de ejecutar `docker compose up`. Recuarda añadir `--build` si necesitas cambiar de la imagen de ruby de desarrollo a producción o viceversa.

## Modo Producción de Verdad  

No tengo ni idea de por qué alguien querría poner esto en producción. Pero no se necesitan pasos especiales para ello. Tan sólo asegúrate de seguir los pasos del proveedor de hosting que estés utilizando y no olvides configurar la conexión a la base de datos en `config/database.yml` y la configuración de Minio en las credenciales de Rails.







