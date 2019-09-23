# frozen_string_literal: true

module Cinema
  class MovieReservesAPI < Grape::API
    namespace :movie_reserves do
      desc 'Redirection'
      get do
        redirect '/v1'
      end

      params do
        requires :from, type: Date
        requires :to, type: Date
      end
      get :search do
        search_params = params.slice(:from, :to)
        movies_reserves = MovieReservesService.search_reservations(search_params)

        error!(movies_reserves.failure, 400) unless movies_reserves.success?

        movies_reserves.success
      end

      desc 'Movies shown by day list'
      params do
        requires :movie_id, type: Integer
        requires :date, type: Date
        requires :person_name, type: String
      end
      post do
        reserve_params = params.slice(:movie_id, :date, :person_name)
        movies_reserves = MovieReservesService.add_reserve(reserve_params)

        error!(movies_reserves.failure, 400) unless movies_reserves.success?

        movies_reserves.success
      end
    end
  end
end
