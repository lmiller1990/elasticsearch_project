require 'rails_helper'

RSpec.describe PageViewsController, type: :controller do
  class ElasticSearcherMock
    def search(opts); end
  end

  describe 'GET /' do
    it 'returns 200 success' do

      allow(ElasticSearcher).to receive(:new).and_return ElasticSearcherMock.new
      get :index

      expect(response.status).to be 200
    end
  end
end
