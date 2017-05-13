[![Build Status](https://travis-ci.org/ruupert/eduroam-location-api.png)](https://travis-ci.org/ruupert/eduroam-location-api) [![Code Climate](https://codeclimate.com/github/ruupert/eduroam-location-api.png)](https://codeclimate.com/github/ruupert/eduroam-location-api) [![Coverage Status](https://coveralls.io/repos/github/ruupert/eduroam-location-api/badge.svg)](https://coveralls.io/github/ruupert/eduroam-location-api) [![Dependency Status](https://gemnasium.com/badges/github.com/ruupert/eduroam-location-api.svg)](https://gemnasium.com/github.com/ruupert/eduroam-location-api)

An attempt on creating an api for eduroam access point placement onto the 'Where can I eduroam'-map. This application is intended to work as an intermediary between organization(s) and the party responsible for adding the locations.

[Wiki](https://github.com/ruupert/eduroam-location-api/wiki)

[Latest build @ heroku](https://eduroam-api.herokuapp.com/)

## Setup

```sh
# git clone https://github.com/ruupert/eduroam-location-api.git
# bundle install
# export EDUROAM_API_ADMIN_USERNAME=username
# export EDUROAM_API_ADMIN_PW=secret
# export EDUROAM_API_DEFAULT_LANGS=fi,se
# export NRO_COUNTRY=fi
# export GMAPAPI=<Google Maps API-key>

```

Edit config/database.yml to point to your database

```sh
# rake db:create
# rake db:migrate
# rails server
```

Using the set username and password you can access /institutions and /import paths. 
 
 
 #### Issues
 
 - import functionality can't handle all types of addresses. The application does not __currently__ provide any way for the admin to edit locations.
 - importer doesn't fill the missing EDUROAM_API_DEFAULT_LANGS
 - many more...
 
 
 

