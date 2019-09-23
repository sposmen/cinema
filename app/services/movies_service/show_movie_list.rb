# frozen_string_literal: true

module MoviesService
  class ShowMovieList
    include Dry::Transaction

    step :validate
    step :search

    def validate(day)
      unless day.is_a?(Integer) && day >= 0 && day < 7
        return Failure(error: INVALID_DAY_MSG)
      end

      Success(day)
    end

    def search(day)
      movies = Movie.where(
        Sequel.lit("(days_shown::bit(7) & #{BIT_DAYS[day]}::bit(7)) <> 0::bit(7)")
      )

      movies = movies.map { |movie| MoviesService.show_movie movie }

      Success(movies)
    end
  end
end
