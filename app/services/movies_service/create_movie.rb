# frozen_string_literal: true

module MoviesService
  class CreateMovie
    include Dry::Transaction

    step :validate
    step :create

    def validate(movie_params)
      movie = Movie.new(movie_params)

      return Failure(movie.errors) unless movie.valid?

      Success(movie)
    end

    def create(movie)
      movie.save
      Success(MoviesService.show_movie(movie))
    end
  end
end
