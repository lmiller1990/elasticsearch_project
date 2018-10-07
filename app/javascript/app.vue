<template>
  <div>
    <SearchForm @submit="submit" />
    <canvas id="ctx"></canvas>
    <!--
    <pre>
      {{ JSON.stringify(response, null, 2) }}
    </pre>
    -->
  </div>
</template>

<script>
import axios from 'axios'
import Chart from 'chart.js'
import SearchForm from './src/search_form.vue'
import { parseResponse } from './src/parse_response.js'

export default {
  components: {
    SearchForm
  },

  data() {
    return {
      response: {}
    }
  },

  methods: {
    submit({ start, end, interval, urls }) {
      axios.get('/page_views', {
        params: {
          after: start, 
          before: end, 
          interval,
          urls
        }
      })
        .then((res) => {
          // this.response = res
          const data = res.data.aggregations.by_interval.buckets
          this.drawGraph(data)
        })
    },

    drawGraph(buckets) {
      const { labels, dataset } = parseResponse(buckets)

      const ctx = this.$el.querySelector('#ctx')
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels, // : ['9:00', '10:00', '11:00'],
          datasets: dataset

          /*
          datasets: [
            {
              label: 'AAAA',
              data: [130, 140, 150],
              backgroundColor: 'red'
            },
            {
              data: [230, 130, 350],
              backgroundColor: 'blue'
            },
            {
              data: [190, 290, 210],
              backgroundColor: 'red'
            },
          ]*/
        },

        options: {
          scales: {
            xAxes: [{
              stacked: true
            }],

            yAxes: [{
              stacked: true
            }]
          }
        }
      })
    }
  }
}
</script>

<style scoped>
</style>
