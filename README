# Signage

This application is used to manage the digital signs around campus.


## Getting Started
1. Create and setup your `app/config/app_config.yml` file

2. Create and setup your `app/config/database.yml` file

3. Install the required gems:  
  `bundle install`
  *(or if you're running on production)*
  `bundle install --deployment`

4. Migrate your database:  
   `rake db:migrate`
    
5. Precompile assets:  
   *(in staging or production only)*  
   *(`RAILS_RELATIVE_URL_ROOT` is only needed if the site does not have it's own domain)*  
   `bundle exec rake assets:precompile RAILS_RELATIVE_URL_ROOT=/signage`


## Testing
1. Prepare database
   `rake db:test:prepare`

2. Run the test unit tests
   `rake test`

## Daemon - sign_monitor_ctl.rb
### Manually start deamon
1. cd to your rails app directory

2. Run
    `lib/daemons/sign_monitor_ctl.rb start`

### Using supervisord
1. Make sure you manually deployed your bundle
    `bundle --deployment`

2. setup your supervisord conf file and use the "run" parameter instead of "start"
