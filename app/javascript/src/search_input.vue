<template>
  <div class="form_line">
    <label for="urls">URL</label>
    <textarea class="url" rows="5" id="urls" type="textarea" v-model="url"></textarea>
  </div>
</template>

<script>
export default {
  name: 'SearchInput',

  data() {
    return {
      url: 'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'
    }
  }
}
</script>

<style scoped>
#urls {
  width: 100%;
}
</style>
