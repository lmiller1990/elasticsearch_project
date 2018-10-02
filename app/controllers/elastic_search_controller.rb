class ElasticSearchController < ApplicationController

  def index
    trump = 'http://www.news.com.au/technology/environment/trump-pulls-us-out-of-paris-climate-agreement/news-story/f5c30a07c595a10a81d67611d0515a0a'

    news = 'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'
    smh = 'http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html'

    client = Elasticsearch::Client.new hosts: [
      {
        host: ENV['host'],
        port: ENV['port'],
        user: ENV['user'],
        password: ENV['password'],
        scheme: ENV['schema']
      }
    ],
    log: true

    # API docs https://www.rubydoc.info/gems/elasticsearch-api
    # Example: client.search index: 'myindex', body: { query: { match: { title: 'test' } } }

    result = client.search index: 'events', type: 'event', body: {
      size: 0,
      aggs: {
        first_agg: {
          range: {
            field: 'derived_tstamp',
            ranges: [
              {
                from: '2015-01-01',
                to: '2018-01-01',
              }
            ]
          },
          aggs: {
            second_agg: {
              terms: {
                field: 'page_url'
              },
            }
          }
        }
      }
    }

    render json: JSON.pretty_generate(result)
  end
end
