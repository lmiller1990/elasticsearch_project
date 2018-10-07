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
    puts opts
    @client.search index: 'events', type: 'event', body: {
      "size": 0,
      "query": {
        "bool": {
          "must": [
            {
              "range": {
                "derived_tstamp": {
                  "gte": opts[:after], # 1496307600000,
                  "lte": opts[:before], # 1496307990000,
                  "format": "epoch_millis"
                }
              }
            }
          ],
          "filter": {
            "terms": {
              "page_url": opts[:urls]
            }
          }
        }
      },
      "aggs": {
        "by_interval": {
          "date_histogram": {
            "field": "derived_tstamp",
            "interval": "#{opts[:interval]}m",
            #"size": 0
          },
          "aggs": {
            "by_url": {
              "terms": {
                "field": "page_url",
                #"size": 10
              }
            }
          }
        }
      }
    }
  end
end
