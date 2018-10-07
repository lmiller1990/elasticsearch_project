Welcome to the Elasticsearch test app.

## Running

### On Heroku

Just visit https://hidden-lake-93827.herokuapp.com/spa

### Set up environment variables (running locally)

- `cp env.yml.example env.yml`
- enter the credentials for the elasticsearch cluster
- `bundle install` and `yarn install` for dependencies
- `bin/rails server` in one terminal, `bin/webpack-dev-server` in another.
- `localhost:3000/spa`.

## Task 1

`/page_views` is a JSON API. It is used in Task 2. The relevant files are [`page_views_controller.rb`](https://github.com/lmiller1990/elasticsearch_project/blob/master/app/controllers/page_views_controller.rb) and [`elastic_searcher.rb`](https://github.com/lmiller1990/elasticsearch_project/blob/master/app/models/elastic_searcher.rb).

## Task 2

Visit `/spa` locally, or https://hidden-lake-93827.herokuapp.com/spa to try it out. You can use the default date/times and urls, just hit "Submit". You can also try out other intervals, urls, etc.

## Technologies

The backend is just plain old Rails with the recommended elasticsearcher gem. The frontend is using Vue, and integrated to the Rails asset pipeline using the [Webpacker](https://github.com/rails/webpacker) gem. The Vue code is in `app/javascript`. The chart library is [Chart.js](http://www.chartjs.org/).

## Tests

`rspec spec` to run the Rails tests. The only test is place is a very simple controller spec, which isn't very useful, anyway.
`yarn test` for the front end tests. I found TDD useful when writing the function to parse the elastic search JSON response to match the Graph.js API, which is the graph library I used.

## Challenges

The main challenges encountered were:

- learning Elasticsearch and writing the query. I had not used elasticsearch before, and took a little bit of time to realize I should use `date_histogram` to aggregate the data.

- Parsing the JSON response on the front end. The code for that is [here](https://github.com/lmiller1990/elasticsearch_project/blob/master/app/javascript/src/parse_response.js) and the tests are [here](https://github.com/lmiller1990/elasticsearch_project/blob/master/app/javascript/test/parse_response.spec.js). The Vue app is fairly trivial, the main challenge for the frontend was parsing the elasticsearch response to the correct form to be used with Chart.js. Using TDD was very useful here.

## Conclusion and Improvements 

I would like to improve this demo by:

1. Elasticsearch test server, for improved back end tests. Maybe using something like recommended [here](https://medium.com/@rowanoulton/testing-elasticsearch-in-rails-22a3296d989).
2. E2E tests. Using something like Cypress.io to visit SPA, and boot an elasticsearch test server. Visit `/spa` and submit the form, then assert something the chart is rendered.

## Lessons Learned

- I learned about elasticsearch, which seems like a very powerful tool. 
- I decided to try Chart.js out, it seems pretty nice for simple graphs, I am not sure how well it would scale for large, complex graphs.
