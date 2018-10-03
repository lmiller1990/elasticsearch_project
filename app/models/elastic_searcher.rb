class ElasticSearcher
  # API docs https://www.rubydoc.info/gems/elasticsearch-api
  #
  def initialize
    @client = Elasticsearch::Client.new hosts: [
      {
        host: ENV['host'],
        port: ENV['port'],
        user: ENV['user'],
        password: ENV['password'],
        scheme: ENV['schema']
      }
    ]
    # log: true
  end

  # @param opts {Hash} hash containing options for query, including:
  #
  # - urls: [string]
  # - before Date
  # - after Date
  # - interval int + units. eg: '15m'
  def search(opts)
    @client.search index: 'events', type: 'event', body: {
      size: 0,
      aggs: {
        first_agg: {
          range: {
            field: 'derived_tstamp',
            ranges: [
              {
                from: opts[:after],
                to: opts[:before],
                size: 0,
                interval: '15m',

              }
            ]
          },
          aggs: {
            second_agg: {
              terms: {
                field: 'page_url'
              }
            }
          }
        }
      }
    }

  end
end
