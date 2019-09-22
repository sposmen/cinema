RSpec.describe Cinema::MoviesAPI do
  describe "Movie Creation" do
    let(:movie_params) {
      {
        name: Faker::Name.name,
        description: Faker::Lorem.paragraph,
        image_url: Faker::Internet.url,
        days_shown: [true, false, true, false, true, false, true]
      }
    }
    subject(:create_movie) {
      response = post '/v1/movies', movie_params
      JSON.parse(response.body, symbolize_names: true)
    }

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
end
