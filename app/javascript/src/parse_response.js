/**
 * parse API response to appropriate shape for graph.js.
 * Eg:
 *
 *  labels: ['9:00', '10:00', '11:00'],
 *
 *  datasets: [
 *    {
 *      label: 'smh.com/article/....',
 *      data: [130, 140, 150],
 *      backgroundColor: 'red'
 *    },
 *    {
 *      label: 'dailytelegraph.com/...',
 *      data: [230, 130, 350],
 *      backgroundColor: 'blue'
 *    },
 *  ]
 *
 *  @param {Array} the Elasticsearch Response
 *  The structure is like this:
 *
 *  [
 *    {
 *      "key_as_string": "2017-06-01T03:15:00.000Z",
 *      "doc_count": 8926,
 *      "by_url": {
 *        "buckets": [
 *          {
 *            "key": "https://.......
 *            "doc_count": 8396
 *          }
 *  So we should loop over the array, where each element 
 *  is an interval (eg 15m), then get the key, which
 *  represents the article, and the doc_count, which is the
 *  number of events.
 *
 */

// some random colors for the graph
const colors = 'red blue green yellow blue pink'.split(' ')

export function parseResponse(buckets) {
  const urlsWithCount = {}
  const urls = getUniqueUrls(buckets)

  for (let u in urls) {
    const url = urls[u]
    urlsWithCount[url] = {}
    urlsWithCount[url]['counts'] = []
    urlsWithCount[url]['color'] = colors[u] || 'purple'
  }

  const labels = []

  for (let bucket of buckets) {
    labels.push(parseTime(bucket['key_as_string']))

    const urlBuckets = bucket['by_url'].buckets

    for (const url of urls) {
      const contains = urlBuckets.find(x => x['key'] === url)
      if (contains) {
        urlsWithCount[url].counts.push(contains['doc_count'])
      } else {
        urlsWithCount[url].counts.push(0)
      }
    }
  }

  const dataset = []
  for (const d in urlsWithCount) {
    // format for chart.js
    dataset.push({
      label: d,
      data: urlsWithCount[d].counts,
      backgroundColor: urlsWithCount[d].color
    })
  }

  return { labels, dataset }
}

export function getUniqueUrls(buckets) {
  const urls = []
  for (let bucket of buckets) {
    const urlBuckets = bucket['by_url'].buckets

    for (const urlBucket of urlBuckets) {
      const url = urlBucket['key']

      if (!urls.includes(url)) {
        urls.push(url)
      }
    }
  }

  return urls
}

/**
 * simple function to format date nicely
 * no need to bother with timezones etc for simple demo
 * @param {String} JavaScript datetime (2017-06-01T03:15:00.000Z)
 * @returns {String} Time in hh:mm
 */
export function parseTime(time) {
  const timePart = time.split('T')[1]
  return timePart.slice(0,5)
}
