#!/bin/bash
set -e

echo "Executing bundle exec 'rake db:create' ..."
RAILS_ENV=production bundle exec rake db:create
