import { parseResponse, parseTime, getUniqueUrls } from '../src/parse_response.js'
import { buckets } from './fixtures/response.json'

describe('parseResponse', () => {
  it('parses a response to match the graph.js API', () => {
    const { labels, dataset } = parseResponse(buckets)

    expect(labels).toEqual(['03:15', '03:30'])
    expect(dataset).toEqual([
      { label: 'https://news.com.au', data: [ 1, 3 ] },
      { label: 'https://smh.com.au', data: [ 2, 4 ] }
    ])
  })
})

describe('parseTime', () => {
  it('formats time in hh:mm', () => {
    const time = '2017-06-01T03:15:00.000Z'
    const expected = '03:15'

    const actual = parseTime(time)

    expect(actual).toBe(expected)
  })
})

describe('getUniqueUrls', () => {
  it('gets all unique urls from buckets', () => {
    const actual = getUniqueUrls(buckets) 

    expect(actual).toEqual([
      'https://news.com.au',
      'https://smh.com.au'
    ])
  })
})
