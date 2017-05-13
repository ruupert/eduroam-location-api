[![Build Status](https://travis-ci.org/ruupert/eduroam-location-api.png)](https://travis-ci.org/ruupert/eduroam-location-api) [![Code Climate](https://codeclimate.com/github/ruupert/eduroam-location-api.png)](https://codeclimate.com/github/ruupert/eduroam-location-api) [![Coverage Status](https://coveralls.io/repos/github/ruupert/eduroam-location-api/badge.svg)](https://coveralls.io/github/ruupert/eduroam-location-api) [![Dependency Status](https://gemnasium.com/badges/github.com/ruupert/eduroam-location-api.svg)](https://gemnasium.com/github.com/ruupert/eduroam-location-api)

An attempt on creating an api for eduroam access point placement onto the 'Where can I eduroam'-map. This application is intended to work as an intermediary between organization(s) and the party responsible for adding the locations.

[Wiki](https://github.com/ruupert/eduroam-location-api/wiki)

[Latest build @ heroku](https://eduroam-api.herokuapp.com/)

## Setup

```sh
# git clone https://github.com/ruupert/eduroam-location-api.git
# cd eduroam-location-api
# bundle install
# export EDUROAM_API_ADMIN_USERNAME=username
# export EDUROAM_API_ADMIN_PW=secret
# export EDUROAM_API_DEFAULT_LANGS=fi,se
# export NRO_COUNTRY=fi
# export GMAPAPI=<Google Maps API-key>

```
EDUROAM_API_DEFAULT_LANGS controls the other languages that are added by default besides english (which is mandatory).


Edit config/database.yml to point to your database

```sh
# rake db:create
# rake db:migrate
# rails server
```

Using the set username and password you can access /institutions and /import paths. 
 
 #### Issues
 
 - Import functionality can't handle all types of addresses. The application does not __currently__ provide any way for the admin to edit locations.
 - Importer doesn't fill the missing EDUROAM_API_DEFAULT_LANGS
 - Importer produces wrong minute -character for coordinates. 
 - Importer/exporter depends on comma separated values for realm and contact information and thus when adding a new institution via /institutions/new, you most likely need to add equal amount of contact info-types (name, email and phone)
 - Importer currently proceeeds to add locations and entries even if the institution already exists. Workaround: Use the import -function only once.
 - If AP count is set to 0 in some institution location, then it still shows up on get locations, which might be a bit confusing.
 - API-response is in JSON format which is not not so human readable: Need to provide separate output with tab delimeters. 
 - Currently there is no way to add new organization info and policy urls and consequently no means to delete them.
 - Move environment variables to a configuration file. 
 - many more...
 
 #### ToDo
 
 - Code refactoring: Moving code to their appropriate places. Like moving code out from controllers to models. 
 - Many of the RSpec tests are misplaced and they do not use FactoryGirl for fixtures: Need to organize them better. 
 - Institution API-key regeneration -button for the admin
 - Exporter default loc_name tag is not really informative as such. In case of not imported location, this may be set as default to "#{location address}, #{institution name}"
 - Rolling back an institution to some specific date by deleting all records belonging to the institution after the given date.
 - Manual edit capability for the admin: Main function would be to fix addresses that the importer did not detect correctly.
 - Apply GMapHandler to the importer -function: Many problems that need to be solved (e.g. some incomplete finnish addresses may resolve to swedish).  
 - Users cannot add new organization SSIDs currently. Need to provide a method of adding and deleting them.
 #### Notes
 
 - This application has been tested on Sqlite3 and PostgreSQL. One query may be such which makes this application not work on other databases.
  
 
 

