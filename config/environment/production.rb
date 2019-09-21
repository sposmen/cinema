require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://postgres@localhost:5434/cinema_production')

