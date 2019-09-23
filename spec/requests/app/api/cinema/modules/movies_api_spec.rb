# frozen_string_literal: true

RSpec.describe Cinema::MoviesAPI do
  describe 'Movie Creation' do
    let(:movie_params) do
      {
        name: Faker::Name.name,
        description: Faker::Lorem.paragraph,
        image_url: Faker::Internet.url,
        days_shown: [true, false, true, false, true, false, true]
      }
    end
    subject(:create_movie) do
      response = post '/v1/movies', movie_params
      JSON.parse(response.body, symbolize_names: true)
    end

    context 'on success' do
      it 'response with required attrs' do
        is_expected.to include(:id, :name, :description, :image_url, :days_shown)
        is_expected.not_to include(:error)
      end
    end

    context 'on error' do
      let(:movie_params) { {} }
      it 'shows errors' do
        is_expected.to include(:error)
        is_expected.not_to include(:id)
      end
    end
  end

  describe 'Movie List by Day' do
    let(:query) { { day: 0 } }

    let(:movie_name) { Faker::Name.name }
    let(:days_shown_array) { [true, false, true, false, true, false, true] }
    let(:days_shown) { MoviesService.days_sum days_shown_array }

    let!(:movie) { Movie.create(name: movie_name, days_shown: days_shown) }

    subject(:search) do
      response = get '/v1/movies/search', query
      JSON.parse(response.body, symbolize_names: true)
    end

    context 'on success' do
      context 'handles the movie for Monday' do
        it do
          is_expected.to include(
            hash_including(
              id: movie.id,
              name: movie_name,
              days_shown: days_shown_array
            )
          )
        end
      end

      context 'handles empty movies when no result' do
        let(:query) { { day: 1 } }
        it do
          is_expected.to be_empty
        end
      end
    end

    context 'on error' do
      context 'when bad day' do
        let(:query) { { day: 8 } }
        it 'shows errors' do
          is_expected.to include(error: 'Invalid day parameter')
        end
      end
      context 'when bad day' do
        let(:query) {}
        it 'shows errors' do
          is_expected.to include(error: 'day is missing')
        end
      end
    end
  end
end
