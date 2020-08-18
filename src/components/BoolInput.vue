<template>
    <div id="bool-parser">
        <input v-model="boolInput" @keyup="doTheThing" placeholder="Your logic goes here" name="boolstring" />

        <pre><strong>Input</strong>:<br/>       {{boolInput}}</pre>
        <pre>---<br/>{{ parser.lexer }}</pre>
        <pre><strong>Output size</strong>: {{output.length}}<br/>{{ output }}</pre>
    </div>
</template>

<script>

import { parseBooleanExpression } from 'inequality-grammar';

export default {
    data() {
        return {
            // mathInput: 'Derivative(y,x,x)',
            boolInput: 'A AND (B OR NOT C)',
            parser: {},
            output: ''
        }
    },
    methods: {
        doTheThing() {
            try {
                this.output = parseBooleanExpression(this.boolInput);
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
