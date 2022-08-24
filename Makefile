setup:
	cp -n .env.example .env || true
	bin/setup

start:
	bin/rails s -p 3000 -b "0.0.0.0"

console:
	bin/rails console

test:
	NODE_ENV=test bin/rails test

deploy:
	git push heroku main
	heroku rake db:migrate
	heroku open

lint: lint-code

lint-code:
	bundle exec rubocop
	bundle exec slim-lint app/views/

lint-safe-fix:
	bundle exec rubocop -a

lint-hard-fix:
	bundle exec rubocop -A

check: lint test

ci-setup: setup
	# cp -n .env.example .env || true
  	# bundle install --without production development
	# yarn install
	# RAILS_ENV=test bin/rails db:prepare
	# bin/rails db:fixtures:load

.PHONY: test
