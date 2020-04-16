<template>
    <div id="container">
        <h1>Symbolic math parser for <a href="https://isaacphysics.org">Isaac Physics</a></h1>
        <p>Type some maths, check that the tree gets generated correctly.</p>
        <input v-model="mathInput" @keyup="doTheThing" placeholder="Your math goes here" name="mathstring" />

        <pre><strong>Input</strong>:<br/>       {{mathInput}}</pre>
        <pre>---<br/>{{ parser.lexer }}</pre>
        <pre><strong>Output size</strong>: {{output.length}}<br/>{{ output }}</pre>
    </div>
</template>

<script>

import { parseExpression } from 'inequality-grammar';

export default {
    data() {
        return {
            // mathInput: 'Derivative(y,x,x)',
            mathInput: '',
            parser: {},
            output: ''
        }
    },
    methods: {
        doTheThing() {
            try {
                this.output = parseExpression(this.mathInput);
            } catch (error) {
                this.output = `Some error occurred: ${error}`
            }
        }
    },
    mounted() {
        this.doTheThing()
    }
}
</script>

<style lang="scss" scoped>
#container {
    width: 80%;
    margin: 0 auto;
}

input {
    width: 97%;
    margin: 0;
    line-height: 1em;
    font-size: 2em;
    padding: 0.5em;
}

pre {
    font-size: 1.2em;
}
</style>
