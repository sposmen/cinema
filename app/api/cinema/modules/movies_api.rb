module Cinema
  class MoviesAPI < Grape::API
    resource :movies do
      desc 'Movies shown by day list'
      params do
        requires :day, type: Integer, documentation: { example: '0 for Monday, 6 for Sunday' }
      end
      get do
        { hello: params[:day] }
      end
    end
  end
end
