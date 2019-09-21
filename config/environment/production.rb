require 'sequel'

DB = Sequel.connect('postgres://localhost:5434/cinema_production', user: 'postgres')
