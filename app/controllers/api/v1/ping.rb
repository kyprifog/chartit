module API
  module V1
    class Ping < Grape::API
      include API::V1::Defaults
      get '/ping' do
        { response: params[:pong] || 'pong' }
      end
    end
  end
end
