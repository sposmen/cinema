# frozen_string_literal: true

class MovieReserve < Sequel::Model
  self.strict_param_setting = false
  plugin :validation_helpers
  def validate
    validates_unique(%i[movie_id date])
  end
end
