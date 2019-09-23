# frozen_string_literal: true

module MovieReservesService
  class AddReserve
    include Dry::Transaction

    step :validate_name
    step :validate_date
    step :validate_occupancy
    step :add

    def validate_name(reserve_params)
      # Check name
      reserve_params[:person_name] = reserve_params[:person_name].strip
      return Failure(error: PERSON_NAME_MIN_SIZE) unless reserve_params[:person_name].size > 1

      Success(reserve_params)
    end

    def validate_date(reserve_params)
      # Check date
      reserve_params[:date]
      return Failure(error: OLD_DATE_MESSAGE) if reserve_params[:date] < Date.today

      day_to_check = reserve_params[:date].wday - 1
      movie = MovieReservesService.search_movie_day(reserve_params[:movie_id], day_to_check)
      return Failure(error: NOT_SHOWN_MSG) if movie.empty?

      Success(reserve_params)
    end

    def validate_occupancy(reserve_params)
      # Check Current occupancy
      movie_reserve = MovieReserve.find_or_new(
        movie_id: reserve_params[:movie_id],
        date: reserve_params[:date]
      )
      if movie_reserve.new?
        # TODO: check a massive way to set find_or_new
        movie_reserve.movie_id = reserve_params[:movie_id]
        movie_reserve.date = reserve_params[:date]
        movie_reserve.person_list = reserve_params[:person_name]
      else
        occupancy = movie_reserve.person_list.split("\n")
        return Failure(error: MAX_OCCUPANCY_MSG) if occupancy.size == MAX_OCCUPANCY

        occupancy << reserve_params[:person_name]
        movie_reserve.person_list = occupancy.join("\n")
      end

      Success(movie_reserve)
    end

    def add(movie_reserve)
      movie_reserve.save

      Success(MovieReservesService.show_reserve(movie_reserve))
    end
  end
end
