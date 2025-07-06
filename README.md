[This README is also available in Spanish](README_es.md).

# README
This respository uses **git lfs**.

This application can run either as a couple of Docker containers (development mode) or as a normal Ruby on Rails application (production mode).

## Development mode
To run it in *Docker*, follow these steps:

1. Install Docker (duh).

2. Run docker compose up in the root folder.

3. You can access the web interface at localhost:80. You may access the database on port 5555.

There is an admin system within the webpage for changing the data. You must set `admin_password` in rail's credentials to be able to access it. 

## Docker Production mode
You can run this app as it is in production mode just by changing the cofiguration in the `.env` file before running `docker compose up`. Remember to add `--build` if you need to change the ruby image from development to production or viceversa. 

## Actual Production mode
I have no idea why anyone would want to put this in production. But no special steps are needed to run this in production. Just make sure to follow the steps required by the host you are using and don't forget to configure the database connection in config/database.yml and the MinIO connection in rails credentials.