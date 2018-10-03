
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

    <input type="submit" value="Submit">
  </form>
</template>

<script>
export default {
  name: 'SearchForm',

  data() {
    return {
      start: '2017-06-01',
      end: '2017-06-03',
      interval: 15
    }
  },

  methods: {
    submit() {
      this.$emit('submit', {
        start: this.toUnixMs(this.start),
        end: this.toUnixMs(this.end),
        interval: this.interval
      })
    },

    toUnixMs(date) {
      return Math.ceil(new Date(date).getTime())
    }
  }
}
</script>

<style scoped>
form {
  display: flex;
}
</style>
