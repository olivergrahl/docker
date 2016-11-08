#!/bin/bash
set -e

service elasticsearch start

# Set up DB based on ENV variables
su zammad -c '/setup_db.sh'

service postfix start

# scheduler
zammad run worker start &

# websockets
zammad run websocket start &

# puma
# zammad run web start &
su - zammad -c 'export PATH=/opt/zammad/bin:$PATH && export GEM_PATH=/opt/zammad/vendor/bundle/ruby/2.3.0/ && ./vendor/bundle/ruby/2.3.0/bin/puma -e production -p 3000' &

service nginx start

/bin/bash
