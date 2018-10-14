spotlight
=========

[![Build Status](https://travis-ci.org/projectblacklight/spotlight.png?branch=master)](https://travis-ci.org/projectblacklight/spotlight) | [![Gem Version](https://badge.fury.io/rb/blacklight-spotlight.png)](http://badge.fury.io/rb/blacklight-spotlight) | [Release Notes](https://github.com/projectblacklight/spotlight/releases) | [Design Documents](https://github.com/projectblacklight/spotlight/releases/tag/v0.0.0)

Spotlight is open source software that enables librarians, curators, and other content experts to easily build feature-rich websites that showcase collections and objects from a digital repository, uploaded items, or a combination of the two. Spotlight is a plug-in for [Blacklight](https://github.com/projectblacklight/blacklight), an open source, Ruby on Rails Engine that provides a basic discovery interface for searching an Apache Solr index.

Read more about what Spotlight is, our motivations for creating it, and how to install and configure it in the [wiki pages](https://github.com/projectblacklight/spotlight/wiki). You might also want to take a look at our demo videos, especially the [tour of a completed Spotlight exhibit](https://www.youtube.com/watch?v=_A7vTbbiF4g) and the walkthrough of [building an exhibit with Spotlight](https://www.youtube.com/watch?v=qPJtgajJ4ic).

## Requirements

1. Ruby (2.3.0 or greater)
2. Rails (5.1 or greater)
3. Java (7 or greater) *for Solr*
4. ImageMagick (http://www.imagemagick.org/script/index.php) due to [carrierwave](https://github.com/carrierwaveuploader/carrierwave#adding-versions)

## Installation

To bootstrap a new Rails application:

```
$ rails new app-name -m https://raw.githubusercontent.com/harvard-library/spotlight/harvard_development/template.rb
```

or from an existing Rails application:

```
$ rake rails:template LOCATION=https://raw.githubusercontent.com/harvard-library/spotlight/harvard_development/template.rb
```

*During this process you will be prompted to enter an initial administrator email and password (this is a super-admin that can administer any exhibit in the installation).* If you choose not to create one, the first user will be given administrative privileges.

Change directories to your new application:

```
$ cd app-name
```

Run the database migrations:

```
$ rake db:migrate
```

Start Solr (possibly using `solr_wrapper` in development or testing):

```
$ solr_wrapper
```

and the Rails development server:

```
$ rails server
```

Go to http://localhost:3000 in your browser.

## Configuration

### Default ActionMailer configuration

Spotlight introduces functionality that depends on being able to send emails to exhibit curators and contacts. Be sure to configure your application's environments appropriately (see the Rails Guide for [Action Mailer Configuration](http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration)).

See the [Spotlight wiki](https://github.com/projectblacklight/spotlight/wiki) for more detailed information on configuring Spotlight.

# Developing Spotlight

Spotlight:

* is a Rails engine and needs to be used in the context of a Rails application. We use [engine_cart](https://github.com/cbeer/engine_cart) to create an internal test application at .internal_test_app/
* uses Solr as part of its integration tests. We use [solr_wrapper](https://github.com/cbeer/solr_wrapper) to manage the Solr instance used for development and test.

Our `$ rake ci` and `$ rake spotlight:server` tasks utilize Solr and the testing rails app automatically.

See more detailed instructions for development environment setup at ["Contributing to Spotlight"](https://github.com/projectblacklight/spotlight/wiki/Contributing-to-Spotlight)

## Developing React Assets

### Requirements

1. [Node.js](https://nodejs.org/en/) (10 or greater)
2. [Yarn](https://yarnpkg.com/en/docs/install) (package manager)

### Setup

Make sure you have [initialized](#installation) the Spotlight
application using the Rails template:

    $ rails new app-name -m https://raw.githubusercontent.com/ArchimedesDigital/spotlight/master/template.rb

Change directories into the root of your application:

    $ cd app-name

Install npm dependencies:

    $ yarn

Start webpack:

    $ yarn start

Webpack watches for changes in `app/assets/pack` and writes the
compiled output to `app/assets/javascripts/webpack_bundle.js`.

By default, this file will be included in the
`app/assets/javascripts/application.js` application manifest as part
of `//= require_tree .` Functionally, that means that the React assets
will appear in any view that uses `<%= javascript_include_tag
'application' %>`. If this is not the behavior you're after, you'll
want to create a separate layout that can be used on views where you
_do_ want the React assets---be sure to modify
`app/assets/javsacripts/application.js` accordingly.

To load only the webpack bundle, simply include `<%=
javascript_include_tag "webpack_bundle" %>` in the ERB template(s)
where you would like to load the app.

Configuration can be found in `webpack.config.js` and
`package.json`.

You might want to adjust the environment variables in
`.env`. Environment variables set from the command line will override
`.env` variables. Make sure that environment variables intended for
the React application are prefixed with `REACT_APP_`, and pay
attention to the comments in the `.env` file.

## Deploying React Assets

To build the React assets for production, simply run `yarn
build`. (You'll most likely want to run this command as part of the
build process on the remote host server.)

The output will be a static file at
`app/assets/javascripts/webpack_bundle.js`. It will be loaded anywhere
you have included the directive `<%= javascript_include_tag
"webpack_bundle" %>`.

## Tests

### Run all the tests:

```
$ rake
```

This utilizes Solr and the testing rails app automatically.

## Translations

Spotlight ships with [`i18n-tasks`](https://github.com/glebm/i18n-tasks) to help manage translations. To run a translation health check:

```sh
$ bundle exec i18n-tasks health
```

See [developer-facing instructions for enabling translation](https://github.com/projectblacklight/spotlight/wiki/Translations) on the wiki.

## Community


- Join us on the [code4lib Slack](https://code4lib.org/irc)
  - **#blacklight** - a developer-focused channel for discussing implementation, customization, and other software concerns in the larger [Blacklight community](http://projectblacklight.org/)
  - **#spotlight-service** - a service-focused channel for people who support exhibit-builders at institutions already using Spotlight
- Google Groups
  - [Blacklight Development Google group](https://groups.google.com/forum/#!forum/blacklight-development)
  - [Spotlight Community Group](https://groups.google.com/forum/#!forum/spotlight-community) (equivalent to #spotlight-service)
