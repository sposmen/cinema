require 'rake'
require 'bundler'
Bundler.setup
require 'grape-route-helpers'
require 'grape-route-helpers/tasks'

task :environment do
  require File.expand_path('app/api/cinema/api', File.dirname(__FILE__))
end
