#!/bin/bash
set -e

pushd /opt/zammad >/dev/null

  if [[ -z $(grep "adapter: ${DB_ADAPTER}" config/database.yml) ]] || \
     [[ -z $(grep "database: ${DB_DATABASE}" config/database.yml) ]] || \
     [[ -z $(grep "host: ${DB_HOST}" config/database.yml) ]] || \
     [[ -z $(grep "port: ${DB_PORT}" config/database.yml) ]]; then

    # Rewrite config and recreate DB if config above has changed
    rewrite=true
    recreate=true

  fi

  if [[ -z $(grep "username: ${DB_USERNAME}" config/database.yml) ]] || \
     [[ -z $(grep "password: ${DB_PASSWORD}" config/database.yml) ]]; then

    # Only rewrite config if username or password have changed
    rewrite=true

  fi

  if [ $rewrite ]; then

    # Set up DB based on ENV variables (overrides config/database.yml)
    echo 'production:' > config/database.yml
    echo '  adapter: '${DB_ADAPTER} >> config/database.yml
    echo '  database: '${DB_DATABASE} >> config/database.yml
    echo '  pool: 50' >> config/database.yml
    echo '  timeout: 5000' >> config/database.yml
    echo '  username: '${DB_USERNAME} >> config/database.yml
    echo '  password: '${DB_PASSWORD} >> config/database.yml
    echo '  host: '${DB_HOST} >> config/database.yml
    echo '  port: '${DB_PORT} >> config/database.yml

  fi

  if [ $recreate ]; then

    export RAILS_ENV=production
    export PATH=/opt/zammad/bin:$PATH
    export GEM_PATH=/opt/zammad/vendor/bundle/ruby/2.3.0/

    rake db:create
    rake db:migrate
    rake db:seed

    # issue#7 - Elasticsearch not ready in docker.sh at execution of setup.sh - sleep 10 until
    #           elasticsearch is accepting network connections
    sleep 10

    rails r "Setting.set('es_url', 'http://localhost:9200')"
    sleep 15
    rake searchindex:rebuild

  fi

popd >/dev/null
