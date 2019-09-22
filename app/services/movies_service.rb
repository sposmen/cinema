Dir[File.join(__dir__, 'movies_service/*.rb')].each {|file| require file }

module MoviesService
  class MoviesServiceError < StandardError;
  end

  BIT_DAYS = [64, 32, 16, 8, 4, 2, 1].freeze
  INVALID_DAY_MSG = 'Invalid day parameter'

  def self.create_movie(movie_params)
    movie_params[:days_shown] = days_sum(movie_params[:days_shown]) if movie_params.include? :days_shown
    CreateMovie.new.call(movie_params)
  end

  def self.show_movie_list(day)
    ShowMovieList.new.call(day)
  end

  def self.show_movie(movie)
    raise MoviesServiceError, 'Wrong movie object' unless movie.valid?

    movie_hash = movie.to_hash
    movie_hash[:days_shown] = days_array movie_hash[:days_shown]
    movie_hash
  end

  def self.days_sum(days)
    sum = 0
    days.each_with_index { |v, idx| sum += BIT_DAYS[idx] if v }
    sum
  end

  def self.days_array(days_shown)
    ("%07d" % days_shown.to_s(2))
      .split('')
      .map { |v| v == '1' ? true : false }
  end
end
