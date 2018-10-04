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
      query: {
        bool: {
          must: [
            {
              range: {
                derived_tstamp: {
                  gte: opts[:after],
                  lte: opts[:before],
                  format: 'epoch_millis'
                }
              }
            }
          ],
          filter: {
            terms: {
              page_url: opts[:urls]
            }
          }
        }
      },

      aggs: {
        group_by_derived_tstamp: {
          terms: {
            field: 'derived_tstamp'
          },

          aggs: {
            group_by_page_url: {
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
