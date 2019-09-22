class MovieReserve < Sequel::Model
  self.strict_param_setting = false
  plugin :validation_helpers
  def validate
    validates_unique([:movie_id, :date])
  end
end
