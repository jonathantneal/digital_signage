# Digital Signage [![Build Status](https://travis-ci.org/biola/digital_signage.png?branch=master)](https://travis-ci.org/biola/digital_signage)

This application is used for managing a collection of digital signs.

### Benefits

* Open Source and free to use
* HTML5 based client letting you run it on anything with a web browser, including but obviously not limited to:
	* **mac mini** (we also have a custom mac app as a webview wrapper, it has some nice features such as hiding the mouse and launching in full screen)
	* **raspberry pi** (we haven't tested it yet but we assume it would work)
	* **iPad** (also supports mobile web app functionality, so you can bookmark the page to your home screen and run it as an app in full screen)
* Slides support images, videos, flash content, and web pages


### Requirements

* CAS server for authentication (*we would like to support o-auth in the future as an alternative*)
* Pubnub account (optional) *This is used for pushing alerts to the signs*


## Getting Started

1. Clone repository

2. Create and setup your `/config/settings.local.yml` file by copying the `.local.yml.example` file in the same directory

3. Create and setup your `/config/database.yml` file by copying the `.yml.example` file in the same directory

4. Create and setup your `/config/newrelic.yml` file by copying the `.yml.example` file in the same directory (you can leave the license_key as it is for development)

5. Install the required gems:
  `bundle install`
  *(or if you're running on production)*
  `bundle install --deployment`

6. Migrate your database:
   `rake db:migrate`

7. Precompile assets:
   *(in staging or production only)*
   *(`RAILS_RELATIVE_URL_ROOT` is only needed if the site does not have it's own domain)*
   `bundle exec rake assets:precompile RAILS_RELATIVE_URL_ROOT=/signage`


## Testing
1. Prepare database
   `rake db:test:prepare`

    *(This needs to be run after doing a database migration)*

2. Run the test unit tests
   `rake test`

## Sign Status Daemon
When displays are active, they ping the digital signage server to let it know that they are still running. This daemon monitors when signs go down and sends an email to notify whoever is signed up to be notified of that sign.

### Manually start deamon
1. cd to your rails app directory

2. Run
    `lib/daemons/sign_monitor_ctl.rb start`

### Using supervisord
1. Make sure you manually deployed your bundle
    `bundle --deployment`

2. setup your supervisord conf file and use the "run" parameter instead of "start"


## Using HTML widgets
The sign player uses iframes to display any type of web page. This provides great flexibility in the type of content you are able to display as slides. We have a few pre-built widgets that we use for our own signs that are included in `public/custom-slides/`. Currently, these include the following:

* **Weather slide** powered by wunderground.com
* **Twitter slide**, showing the most recent tweets to any given account
* **Dropmark slide**, showing a random image from a dropmark.com collection every time a slide is displayed

Take a look at the README in each of these project directories to see how they work and what parameters you need to pass in. For most people in local development, [this link](http://localhost:3000/custom_slides/) should work. Also, feel free to submit a pull request with your own custom slides if they are of general use. Please keep the code clean and make sure that they are well commented. I've included a template folder to get you started.

There are also a few hooks you can use in your HTML widget that are called right before a slide is shown and right after the slide is hidden. These can be implemented as follows:

    function beforeHook() {
      // Do your stuff here right before the slide is shown...
    }
    function afterHook() {
      // Do your stuff here right after the slide is hidden...
    }

To include these widgets as a sign, you have two options:

1. If it's a single page HTML file, you can upload the file just like uploading an image or video.
2. Host it somewhere else: github pages or in your public directory for example. They you just add it as a url to the slide.

**NOTE:** These hooks are only availble if the widget is hosted on the same domain as the signage server. This is because javascript does not let you call functions in an iframe from a different domain.


## Contributing

After forking and then cloning the repo locally, install Bundler (if you haven't already) and then use it
to install the gem dependecies:

    gem install bundler
    bundle install

Once this is complete, you should be able to run the test suite:

    rake

At this point `rake` should run without error or warning and you are ready to
start working on your patch! Create a fork and hack away. When you are ready to submit your change and have written tests for all your changes, you may submit a pull request. We will review your change and if all tests are passing then we will pull it into master.

Note that you can also run just one test out of the test suite if you're working
on a specific area:

    ruby -Itest test/functional/signs_controller_test.rb


### Roadmap
* o-auth as an alternate form of authentication if you are not using CAS
* Transition from test::unit to Rspec for testing
* Better tests for existing code (written in Rspec)
* Better support for HTML widgets rather than just adding the URL. Maybe a way to install widgets from a central place. Or create widgets using a url then be able to select from a list of available widgets on the slide creation page. It would also be nice if they had meta-data attached to them explaining the parameters that can be set.