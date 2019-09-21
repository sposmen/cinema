class MoviesService
  class MoviesServiceError < StandardError;
  end

  BIT_DAYS = [64, 32, 16, 8, 4, 2, 1].freeze
  INVALID_DAY_MSG = 'Invalid day parameter'

  class << self
    def create_movie(movie_params)
      movie_params[:days_shown] = days_sum(movie_params[:days_shown]) if movie_params.include? :days_shown
      movie = Movie.new(movie_params)
      return movie unless movie.valid?

      movie.save
    end

    def show_movie_list(day)
      return OpenStruct.new(
        errors: {error: INVALID_DAY_MSG}
      ) unless day.is_a?(Integer) && day >= 0 && day < 7

      movies = Movie.where(
        Sequel.lit("(days_shown::bit(7) & #{BIT_DAYS[day]}::bit(7)) <> 0::bit(7)")
      )

      movies.map { |movie| show_movie movie }
    end

    def show_movie(movie)
      raise MoviesServiceError, 'Wrong movie object' unless movie.valid?

      movie_hash = movie.to_hash
      movie_hash[:days_shown] = days_array movie_hash[:days_shown]
      movie_hash
    end

    def days_sum(days)
      sum = 0
      days.each_with_index { |v, idx| sum += BIT_DAYS[idx] if v }
      sum
    end

    def days_array(days_shown)
      ("%07d" % days_shown.to_s(2))
        .split('')
        .map { |v| v == '1' ? true : false }
    end
  end
end
