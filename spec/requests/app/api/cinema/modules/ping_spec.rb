# frozen_string_literal: true

RSpec.describe Cinema::Ping do
  subject(:ping) do
    response = get '/v1/ping'

    JSON.parse(response.body, symbolize_names: true)
  end

  it 'has the ping keys' do
    is_expected.to include(:branch, :commit, ping: 'pong')
  end
end
