# frozen_string_literal: true

module MovieReservesService
  class SearchReserves
    include Dry::Transaction

    step :validate
    step :search

    def validate(date_range)
      unless date_range[:from].is_a?(Date) && date_range[:to].is_a?(Date) && date_range[:to] >= date_range[:from]
        return Failure(error: INVALID_DATES_MSG)
      end

      Success(date_range)
    end

    def search(date_range)
      movies_reserves = MovieReserve.where(date: date_range[:from]..date_range[:to])
      movies_reserves = movies_reserves.map { |movie_reserve| MovieReservesService.show_reserve movie_reserve }
      Success(movies_reserves)
    end
  end
end
