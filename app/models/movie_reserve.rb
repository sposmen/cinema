class MovieReserve < Sequel::Model
  plugin :validation_helpers
  def validate
    validates_unique([:movie_id, :date])
  end
end
