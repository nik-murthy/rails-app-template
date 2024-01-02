def add_gems
  gem 'devise'
  gem 'friendly_id'
  gem 'name_of_person'
  gem 'activerecord-session_store'
  # capybara
  # selenium

  gem_group :development, :test do
    # dotenv
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'faker'
  end

  gem_group :test do
    gem 'capybara'
    gem 'selenium-webdriver'
    gem 'capybara-screenshot'
  end
end

def add_users
  # Install Devise
  generate 'devise:install'

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, 'User', 'first_name', 'last_name', 'admin:boolean'

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob('db/migrate/*').max_by { |f| File.mtime(f) }
    gsub_file migration, /:admin/, ':admin, default: false'
  end

  # name_of_person gem
  append_to_file('app/models/user.rb', '\nhas_person_name\n', after: 'class User < ApplicationRecord')
end

def add_friendly_id
  generate 'friendly_id'
end

def add_rspec
  generate 'rspec:install'
end

add_gems

after_bundle do
  add_users
  add_friendly_id

  # setup_active_record_as_session_store
  # add_uuid_and_use_for_id
  # add_test_containers
  # configure_pg_container_in_procfile

  # Migrate
  #   rails_command 'db:create'
  #   rails_command 'db:migrate'

  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )

  say
  say 'Scaffold app successfully created! 👍', :green
  say
  say 'Switch to your app by running:'
  say "$ cd #{app_name}", :yellow
  say
  say 'Then run:'
  say '$ ./bin/dev', :green
end
