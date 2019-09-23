# frozen_string_literal: true

RSpec.describe Cinema::MovieReservesAPI do
  let(:movie_name) { Faker::Name.name }
  let(:days_shown_array) { [true, false, true, false, true, false, true] }
  let(:days_shown) { MoviesService.days_sum days_shown_array }

  let!(:movie) { Movie.create(name: movie_name, days_shown: days_shown) }

  describe 'Add reservation' do
    let(:date) { (date = Date.parse('Monday')) >= Date.today ? date : (date + 1.week) }
    let(:reservation_params) do
      {
        movie_id: movie.id,
        date: date,
        person_name: Faker::Name.name
      }
    end
    subject(:add_reservation) do
      response = post '/v1/movie_reserves', reservation_params
      JSON.parse(response.body, symbolize_names: true)
    end

    context 'on success' do
      it 'response with required attrs' do
        is_expected.to include(:movie_id, :date, person_list: array_including(reservation_params[:person_name]))
        is_expected.not_to include(:error)
      end
    end

    context 'on error' do
      context 'when no/avoided required params' do
        let(:reservation_params) { {} }
        it 'shows errors' do
          is_expected.to include(:error)
          is_expected.not_to include(:id)
        end
      end

      context 'when more than occupancy' do
        before do
          person_list = Array.new(10) { Faker::Name.name }
          movie_reserve = MovieReserve.new
          movie_reserve.movie_id = movie.id
          movie_reserve.date = date
          movie_reserve.person_list = person_list.join("\n")
          movie_reserve.save
        end

        it 'shows errors' do
          is_expected.to include(:error)
          is_expected.not_to include(:id)
        end
      end
    end
  end

  describe 'Reserves search by date range' do
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
    end
  end
end
