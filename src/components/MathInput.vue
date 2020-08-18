<template>
    <div id="maths-parser">
        <input v-model="mathInput" @keyup="doTheThing" placeholder="Your math goes here" name="mathstring" />

        <pre><strong>Input</strong>:<br/>       {{mathInput}}</pre>
        <pre>---<br/>{{ parser.lexer }}</pre>
        <pre><strong>Output size</strong>: {{output.length}}<br/>{{ output }}</pre>
    </div>
</template>

<script>

import { parseMathsExpression } from 'inequality-grammar';

export default {
    data() {
        return {
            // mathInput: 'Derivative(y,x,x)',
            mathInput: 'a+sin(x)',
            parser: {},
            output: ''
        }
    },
    methods: {
        doTheThing() {
            try {
                this.output = parseMathsExpression(this.mathInput);
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
