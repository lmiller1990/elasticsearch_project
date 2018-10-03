<template>
  <div>
    <SearchForm @submit="submit" />
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
    }
  },

  methods: {
    submit({ start, end, interval }) {
      axios.get('/page_views', {
        params: {
          after: start, 
          before: end, 
          interval
        }
      })
        .then((res) => {
          console.log(res)
        })
    }
  }
}
</script>

<style scoped>
</style>
