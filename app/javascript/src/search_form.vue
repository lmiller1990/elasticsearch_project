
<template>
  <form @submit.prevent="submit">
    <div class="form_line">
      <label for="start">Start</label>
      <input
        type="date"
        v-model="startDate"
      >
      <input 
        id="start" 
        type="time"
        v-model="start"
      >
    </div>

    <div class="form_line">
      <label for="end">End</label>
      <input
        type="date"
        v-model="endDate"
      >
      <input 
        id="end" 
        type="time"
        v-model="end"
      >
    </div>

    <div class="form_line">
      <label for="interval">Interval</label>
      <input id="interval" type="number" v-model="interval">m
    </div>

    <SearchInput :url="newsUrl1" />
    <SearchInput :url="smhUrl1" />
    <SearchInput :url="smhUrl2" />

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
      startDate: '2017-06-01',
      endDate: '2017-06-01',
      start: '09:00',
      end: '18:00',
      interval: 15,
      newsUrl1: 'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615',
      smhUrl1: 'http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html',
      smhUrl2: 'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'
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

    toUnixMs(date) {
      return Math.ceil(new Date(date).getTime())
    },

    timeToMs(time) {
      const [hh, mm] = time.split(':').map(x => parseInt(x))

      return (hh * 60 * 60 * 1000) + (mm * 60 * 1000)
    },

    submit() {
      this.$emit('submit', {
        start: this.toUnixMs(this.startDate) + this.timeToMs(this.start),
        end: this.toUnixMs(this.endDate) + this.timeToMs(this.end),
        interval: this.interval,
        urls: this.getUrls().join(',')
      })
    }
  }
}
</script>

<style scoped>
</style>
