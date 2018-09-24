/* eslint-disable */
import Vue from 'vue'
import Router from 'vue-router'
import Players from '@/components/Players'
import Moderator from '@/components/Moderator'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Players',
      component: Players
    },
    {
      path: '/moderator',
      name: 'Moderator',
      component: Moderator
    },
  ]
})
