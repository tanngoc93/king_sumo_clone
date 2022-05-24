web: bundle exec rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV