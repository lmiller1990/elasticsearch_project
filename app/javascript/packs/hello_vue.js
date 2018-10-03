import Vue from 'vue'
import App from '../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('app')
  const app = new Vue({
    el,
    render: h => h(App)
  })
})
