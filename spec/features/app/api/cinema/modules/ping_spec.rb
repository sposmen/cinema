RSpec.describe "requesting /ping" do
  subject(:ping) do
    visit '/v1/ping'
    JSON.parse(page.body, symbolize_names: true)
  end

  it "has the ping keys" do
    is_expected.to include(:branch, :commit, ping: "pong")
  end
end

