[![Build Status](https://travis-ci.org/ruupert/eduroam-location-api.png)](https://travis-ci.org/ruupert/eduroam-location-api) [![Code Climate](https://codeclimate.com/github/ruupert/eduroam-location-api.png)](https://codeclimate.com/github/ruupert/eduroam-location-api) [![Coverage Status](https://coveralls.io/repos/github/ruupert/eduroam-location-api/badge.svg?branch=master)](https://coveralls.io/github/ruupert/eduroam-location-api?branch=master)

An attemnt on creating an api for eduroam access point placement onto the 'Where can I eduroam'-map. This application is intended to work as an intermediary between organization(s) and the party responsible for adding the locations.

Basic features that should be are:

- Registration/login/forgot my password
- Each account gets an individual API-key (important! Needs to be secure)
- Atleast one method of setting location (address,street number,city,ap count)
   -> Write only. Meaning that only possible to add new records where latest distinct counts.
      In other words setting location AP count from X to 0 equals to no record.
   -> Coordinates from Google API
- Ability to get a list of currently set locations
   -> As before all non zero ap count and only latest distinct(address,street number,city) counts.
- Either automatically daily XML export containing current eduroam locations overwriting the previous file
  or a method to request the XML-datafile.

