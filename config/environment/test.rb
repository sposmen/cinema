require 'sequel'

DB = Sequel.connect('postgres://localhost:5434/cinema_test', user: 'postgres')
