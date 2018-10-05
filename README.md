## Running

### Set up environment variables

- `cp env.yml.example env.yml`
- enter the credentials for the elasticsearch cluster

`rails server`


## Task 1

This is the progression I used to write the query using Kibana to test.

First I got all events for a url: 

```json
GET /events/_search
{
  "size": 0,
  "query": {
    "bool": {
      "should": {
        "match": {
          "page_url": "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615"
        }   
      }
    }
  }
}
```

Next I performed the double aggregation:

```json
GET /events/_search
{
  "size": 0,
  "query": {
    "bool": {
      "should": {
        "match": {
          "page_url": "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615"
        }
      }
    }
  },
  "aggs": {
    "group_by_derived_tstamp": {
      "terms": {
        "field": "derived_tstamp"
      },
      "aggs": {
        "group_by_page_url": {
          "terms": {
            "field": "page_url"
          }
        }
      }
    }
  }
}
```

Next I included the timestamps:

- 1496307600000 -> 2017/06/01 9:00:00 AM GMT+09:00
- 1496307660000 -> 2017/06/01 6:01:00 PM GMT+09:00

```json
GET /events/_search
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "page_url": "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615"
          }
        },
        {
          "range": {
            "derived_tstamp": {
              "gte": 1496307600000,
              "lte": 1496307660000,
              "format": "epoch_millis"
            }
          }
        }
      ]
    }
  },
  "aggs": {
    "group_by_derived_tstamp": {
      "terms": {
        "field": "derived_tstamp"
      },
      "aggs": {
        "group_by_page_url": {
          "terms": {
            "field": "page_url"
          }
        }
      }
    }
  }
}
```

Finally, query multiple urls:

```json
GET /events/_search
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "derived_tstamp": {
              "gte": 1496307600000,
              "lte": 1496307680000,
              "format": "epoch_millis"
            }
          }
        }
      ],
      "filter": {
        "terms": {
          "page_url": [
            "http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html",
            "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615"
            ]
        }
      }
    }
  },
  
  "aggs": {
    "group_by_derived_tstamp": {
      "terms": {
        "field": "derived_tstamp"
      },
      "aggs": {
        "group_by_page_url": {
          "terms": {
            "field": "page_url"
          }
        }
      }
    }
  }
}
```

I am not sure where the `interval` should go.

I then tested the query like this: visit `/page_views` with a querystring:

```
http://localhost:3000/page_views?after=1496307600000&before=1496307660000&urls=http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615,http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html
```

## Using date_histogram

It turns out you can use date_histogram to aggregate with a set interval like this:

```
GET /events/_search
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "derived_tstamp": {
              "gte": 1496307600000,
              "lte": 1496307680000,
              "format": "epoch_millis"
            }
          }
        }
      ],
      "filter": {
        "terms": {
          "page_url": [
            "http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html",
            "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615"
            ]
        }
      }
    }
  },
  "aggs": {
    "by_interval": {
      "date_histogram": {
        "field": "derived_tstamp",
        "interval": "15m"
      },
      "aggs": {
        "by_url": {
          "terms": {
            "field": "page_url",
            "size": 10
          }
        }
      }
    }
  }
}
```

## Task 2

Visit `/spa` and sumbit the form as is. Check the console.log for the response. The result is a double aggregation:

data -> aggregations -> group_by_derived_tstamp -> buckets -> group_by_page_url -> buckets

