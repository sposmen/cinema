require 'sequel'
require 'grape'
require 'json'

# Environment
env = ENV.fetch('RUBY_ENV') { 'development' }
require File.expand_path("../config/environment/#{env}", File.dirname(__FILE__))

# Models
Dir[File.join(__dir__, '../app/models/*.rb')].each {|file| require file }

# Services
Dir[File.join(__dir__, '../app/services/*.rb')].each {|file| require file }

require_relative '../app/api/cinema/api'

# require_relative '../app/models/users.rb'
# require_relative '../app/api/version1.rb'
# require_relative '../app/helpers/parser.rb'
# require_relative '../db/db_setup'
