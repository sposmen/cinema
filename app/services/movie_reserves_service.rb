Dir[File.join(__dir__, 'movie_reserves_service/*.rb')].each { |file| require file }

module MovieReservesService
  def self.search_reservations(date_range)
    SearchReserves.new.call(date_range)
  end

  def self.show_reserve(movie_reserve)
    raise MoviesServiceError, 'Wrong movie object' unless movie_reserve.valid?

    movie_reserve.to_hash
  end
end
