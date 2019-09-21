# require_relative '../../../config/application'

# Modules
Dir[File.join(__dir__, 'modules/*.rb')].each { |file| require file }

# FORMATTING_INFO = [:first_name, :last_name, :email, :phone, :created_at]
#
# module FormatInfo
#   def self.format_post_info(info)
#     formatted_hash = Hash.new
#     user_info = info.split(",")
#     formatting_info = FORMATTING_INFO.dup
#     if user_info.length != formatting_info.length
#       raise ArgumentError.new('Attribute names can\'t be blank')
#     else
#       until formatting_info.empty?
#         formatted_hash[formatting_info.shift] = user_info.shift
#       end
#     end
#     formatted_hash
#   end
# end

module Cinema
  class Api < Grape::API
    version 'v1', :using => :path
    format :json

    mount Cinema::Ping
    mount Cinema::MoviesAPI
    mount Cinema::MovieReservesAPI

  end
end
