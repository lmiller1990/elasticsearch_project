<template>
  <div>
    <SearchForm @submit="submit" />
    <pre>
      {{ JSON.stringify(response, null, 2) }}
    </pre>
  </div>
</template>

<script>
import axios from 'axios'
import chartjs from 'chart.js'
import SearchForm from './src/search_form.vue'

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
          this.response = res
          console.log(res)
        })
    }
  }
}
</script>

<style scoped>
</style>
