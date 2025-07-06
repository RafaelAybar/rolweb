[También tienes este README en inglés Spanish](README.md).

# README (Español)
Este repositorio utiliza **git lfs**.

Esta aplicación puede ejecutarse como un par de contenedores de Docker (modo desarrollo) o como una aplicación normal de Ruby on Rails (modo producción).  

## Modo Desarrollo  

Para ejecutarla en Docker, sigue estos pasos:  

1. Instala Docker (:p).  


3. Ejecuta ```sh docker compose up```  en la carpeta raíz:  

4. Puedes acceder a la web en `localhost:80`. También puedes acceder a la base de datos en el puerto `5555`.  

Existe un sistema de admin dentro de la página web para modificar los datos. Debes de establecer `admin_password` en los credenciales de rails para poder acceder a él.

## Modo Producción de Docker
Puedes ejecutar esta applicación en modo de producción simplemente cambiando la confiugración en el archivo `.env` antes de ejecutar `docker compose up`. Recuarda añadir `--build` si necesitas cambiar de la imagen de ruby de desarrollo a producción o viceversa.

## Modo Producción de Verdad  

No tengo ni idea de por qué alguien querría poner esto en producción. Pero no se necesitan pasos especiales para ello. Tan sólo asegúrate de seguir los pasos del proveedor de hosting que estés utilizando y no olvides configurar la conexión a la base de datos en `config/database.yml` y la configuración de Minio en las credenciales de Rails.







