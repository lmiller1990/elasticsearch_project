<template>
  <div class="form_line">
    <label for="urls">URL</label>
    <textarea class="url" rows="5" id="urls" type="textarea" v-model="theUrl"></textarea>
  </div>
</template>

<script>
export default {
  name: 'SearchInput',

  props: {
    url: {
      type: String,
      required: false,
    }
  },

  created() {
    if (this.url) {
      this.theUrl = this.url.slice()
    }
  },

  data() {
    return {
      theUrl: ''
    }
  }
}
</script>

<style scoped>
#urls {
  width: 100%;
}
</style>
