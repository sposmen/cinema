module Cinema
  class Ping < Grape::API
    get :ping do
      {
          ping: "pong",
          branch: `git rev-parse --abbrev-ref HEAD`.chomp,
          commit: `git rev-parse --short HEAD`.chomp
      }
    end
  end
end
