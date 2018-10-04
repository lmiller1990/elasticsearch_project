
<template>
  <form @submit.prevent="submit">
    <div class="form_line">
      <label for="start">Start</label>
      <input 
        id="start" 
        type="date"
        v-model="start"
      >
    </div>

    <div class="form_line">
      <label for="end">End</label>
      <input 
        id="end" 
        type="date"
        v-model="end"
      >
    </div>

    <div class="form_line">
      <label for="interval">Interval</label>
      <input id="interval" type="number" v-model="interval">m
    </div>

    <SearchInput v-for="i in numUrls" />
    <button @click="numUrls += 1">Add Another URL</button>

    <input type="submit" value="Submit">

  </form>
</template>

<script>
import SearchInput from './search_input.vue'

export default {
  name: 'SearchForm',

  components: {
    SearchInput
  },

  data() {
    return {
      numUrls: 1,
      start: '2017-06-01',
      end: '2017-06-03',
      interval: 15
    }
  },

  mounted() {
    this.getUrls()
  },

  methods: {
    getUrls() {
      return Array.from(this.$el.querySelectorAll('.url'))
        .map(x => x.value)
    },

    submit() {
      this.$emit('submit', {
        start: this.toUnixMs(this.start),
        end: this.toUnixMs(this.end),
        interval: this.interval,
        urls: this.getUrls().join(',')
      })
    },

    toUnixMs(date) {
      return Math.ceil(new Date(date).getTime())
    }
  }
}
</script>

<style scoped>
</style>
