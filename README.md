# Digital Signage

This application is used for managing a collection of digital signs.

### Benefits

* Open Source and free to use
* HTML5 based client letting you run it on anything with a web browser
* Slides support images, videos, flash content, and web pages


### Requirements

* CAS server for authentication (*we would like to support o-auth in the future as an alternative*)
* Pubnub account (optional) *This is used for pushing alerts to the signs*


### Roadmap
* o-auth as an alternate form of authentication if you are not using CAS
* Transition from test::unit to Rspec for testing
* Better tests for existing code

## Getting Started

1. Clone repository

2. Create and setup your `app/config/app_config.yml` file

3. Create and setup your `app/config/database.yml` file

4. Install the required gems:  
  `bundle install`
  *(or if you're running on production)*
  `bundle install --deployment`

5. Migrate your database:  
   `rake db:migrate`
    
6. Precompile assets:  
   *(in staging or production only)*  
   *(`RAILS_RELATIVE_URL_ROOT` is only needed if the site does not have it's own domain)*  
   `bundle exec rake assets:precompile RAILS_RELATIVE_URL_ROOT=/signage`


## Testing
1. Prepare database
   `rake db:test:prepare`
    
    *(This needs to be run after doing a database migration)*

2. Run the test unit tests
   `rake test`

## Daemon - sign_monitor_ctl.rb
When displays are active, they ping the digital signage server to let it know that they are still running. This daemon monitors when signs go down and sends an email to notify whoever is signed up to be notified of that sign.

### Manually start deamon
1. cd to your rails app directory

2. Run
    `lib/daemons/sign_monitor_ctl.rb start`

### Using supervisord
1. Make sure you manually deployed your bundle
    `bundle --deployment`

2. setup your supervisord conf file and use the "run" parameter instead of "start"
