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
  margin: 60px auto 0 auto;
  width: 1280px;
  @media screen and (max-width: 1280px) {
    width: 100%;
    margin-left: 2em;
    margin-right: 2em;
  }

  .grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-column-gap: 2em;

    .col {
      width: 1fr;
      
      input {
        margin: 0;
        line-height: 1em;
        font-size: 2em;
        padding: 0.5em;
      }

      pre {
        font-size: 1.2em;
      }

      .maths {
        grid-column: 1;
      }

      .logic {
        grid-column: 2;
      }
    }
  }
}
</style>
