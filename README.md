[This README is also available in Spanish](README_es.md).

# README
This application can run either as a couple of Docker containers (development mode) or as a normal Ruby on Rails application (production mode).

## Development mode
To run it in *Docker*, follow these steps:

1. Install Docker (duh).

2. Create the necessary empty folders for the database. You can do this by running crear_dirs_for_db_data.sh, or if you can't run it, you can create them manually. Some of them may already exist; just make sure the following folders exist under /db_data/:
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
3. Run docker compose up in the root folder.
4. You can access the web interface at localhost:80. You may access the database on port 5555.

You'll find a lot of content already pulled from the database. This should be similar to what can be found in production, but it may contain errors or be incomplete.

The database data is saved in Git to always have it available for testing purposes during development.

## Production mode
I have no idea why anyone would want to put this in production. But no special steps are needed to run this in production. Just make sure to follow the steps required by the host you are using and don't forget to configure the database connection in config/database.yml.