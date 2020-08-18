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
            boolInput: '!(A ^ B) & (B | !C)',
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
