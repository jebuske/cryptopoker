<template>
  <div id="app">
    <H1>Crypto poker</H1>
    <div id="nav">
      <router-link to="/">Players</router-link> |
      <router-link to="/moderator">Moderator</router-link>
    </div>
    <router-view/>
  </div>
</template>

<style lang="scss">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  color: #2c3e50;
  padding: 30px;
}
#nav {
  a {
    font-weight: bold;
    color: #2c3e50;
    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
</style>