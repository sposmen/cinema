# frozen_string_literal: true

Dir[File.join(__dir__, 'movie_reserves_service/*.rb')].each { |file| require file }

module MovieReservesService
  INVALID_DATES_MSG = 'Invalid Date Range'

  OLD_DATE_MESSAGE = 'Date must be greater than, or at least Today'
  MAX_OCCUPANCY = 10
  NOT_SHOWN_MSG = 'Movie not shown in that Date'
  PERSON_NAME_MIN_SIZE = 'Person name must be greater than 0 size'
  MAX_OCCUPANCY_MSG = 'Allowed occupancy raised. Sorry'

  def self.search_reservations(date_range)
    SearchReserves.new.call(date_range)
  end

  def self.add_reserve(reserve_params)
    AddReserve.new.call(reserve_params)
  end

  def self.show_reserve(movie_reserve)
    raise MoviesServiceError, 'Wrong movie object' unless movie_reserve.valid?

    movie_reserve_hash = movie_reserve.to_hash
    movie_reserve_hash[:person_list] = movie_reserve_hash[:person_list].split("\n")
    movie_reserve_hash
  end

  def self.search_movie_day(movie_id, day)
    Movie
      .where(id: movie_id)
      .where(Sequel.lit("(days_shown::bit(7) & #{MoviesService::BIT_DAYS[day]}::bit(7)) <> 0::bit(7)"))
  end
end
