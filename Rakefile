# frozen_string_literal: true

require 'rake'
require 'bundler'
require 'sequel'
Bundler.setup
require 'grape-route-helpers'
require 'grape-route-helpers/tasks'

env = ENV.fetch('RACK_ENV') { 'development' }

task :environment do
  require File.expand_path('app/api/cinema/api', File.dirname(__FILE__))
end

namespace :db do
  desc 'Create database'
  task :create do
    Sequel.connect('postgres://postgres@localhost:5434/postgres') do |db|
      db.execute "CREATE DATABASE cinema_#{env}"
    end
  end
  desc 'Drop database'
  task :drop do
    Sequel.connect('postgres://postgres@localhost:5434/postgres') do |db|
      db.execute "DROP DATABASE IF EXISTS cinema_#{env}"
    end
  end
  desc 'Run migrations'
  task :migrate, [:version] do |_t, args|
    require 'sequel/core'
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(ENV['DATABASE_URL'] || "postgres://postgres@localhost:5434/cinema_#{env}") do |db|
      Sequel::Migrator.run(db, 'db/migrations', target: version)
    end
  end
end
