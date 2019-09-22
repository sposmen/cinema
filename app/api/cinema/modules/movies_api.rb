module Cinema
  class MoviesAPI < Grape::API
    namespace :movies do
      desc 'Redirection'
      get do
        redirect '/v1'
      end

      params do
        requires :day, type: Integer, documentation: { example: '0 for Monday, 6 for Sunday' }
      end
      get '/search' do
        movie_list = MoviesService.show_movie_list(params[:day])

        error!(movie_list.failure, 400) unless movie_list.success?

        movie_list.success
      end

      params do
        requires :id, type: Integer, documentation: { example: '0 for Monday, 6 for Sunday' }
      end
      get ':id' do
        Movie.find(id: params[:id])&.to_hash
      end

      desc 'Adds movie'
      params do
        requires :name, type: String
        requires :days_shown, type: Array, documentation: { example: '0 for Monday, 6 for Sunday' }
        optional :description, type: String
        optional :image_url, type: String
      end

      post do
        movie_params = params.slice(:name, :days_shown, :description, :image_url)

        movie_creation = MoviesService.create_movie(movie_params)

        error!(movie_creation.failure, 400) unless movie_creation.success?

        movie_creation.success
      end
    end
  end
end
