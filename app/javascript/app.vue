<template>
  <div>
    <SearchForm @submit="submit" />
    <div id="chart"></div>
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
    createCanvas() {
      const canvas = document.createElement('canvas')
      canvas.setAttribute('id', 'ctx')

      return canvas
    },

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
          // destroy and recreate chart
          const chartWrapper = this.$el.querySelector('#chart')
          if (chartWrapper.querySelector('#ctx')) {
            chartWrapper.removeChild(chartWrapper.querySelector('#ctx'))
          }

          const canvas = this.createCanvas()
          this.$el.querySelector('#chart').appendChild(canvas)

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
          labels,
          datasets: dataset
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
