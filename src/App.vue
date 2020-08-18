<template>
  <div id="app">
    <p>Symbolic maths and boolean logic parser for <a href="https://isaacphysics.org">Isaac Physics</a> and <a href="https://isaaccomputerscience.org">Isaac Computer Science</a></p>
    <p>Type some expressions, check that the tree gets generated correctly.</p>

    <div class="grid">
      <div class="maths col">
        <MathInput/>
      </div>
      <div class="logic col">
        <BoolInput/>
      </div>
    </div>

  </div>
</template>

<script>
import MathInput from './components/MathInput.vue'
import BoolInput from './components/BoolInput.vue'

export default {
  name: 'app',
  components: {
    MathInput,
    BoolInput
  }
}
</script>

<style lang="scss">
#app {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: black;
  width: 60px auto 0 auto;

  & .grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-gap: 2em;
    grid-auto-rows: mixmax(100px, auto);

    & .col {
      & .maths {
        grid-column: 1 / 2;
        grid-row: 1;
      }

      & .logic {
        grid-column: 2 / 2;
        grid-row: 1;
      }
    }
  }
}
</style>
