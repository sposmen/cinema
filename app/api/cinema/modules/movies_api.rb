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
      get ':day' do
        movie_list = MoviesService.show_movie_list(params[:day])

        error!(movie_list.errors, 400) if movie_list.respond_to? :errors

        movie_list
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

        error!(movie_creation.errors, 400) unless movie_creation.valid?

        MoviesService.show_movie movie_creation
      end
    end
  end
end
