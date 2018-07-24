#!/bin/bash

bundle install
bundle exec bundle exec unicorn -p 3221 
