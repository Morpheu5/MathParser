<template>
    <div>
        <input v-model="mathInput" @keyup="doTheThing" placeholder="Your math goes here" name="mathstring" />

        <pre><strong>Input</strong>:<br/>       {{mathInput}}</pre>
        <pre>---<br/>{{ parser.lexer }}</pre>
        <pre><strong>Output</strong>:<br/>{{ output }}</pre>
    </div>
</template>

<script>
import { Parser, Grammar } from 'nearley';
import grammar from '../assets/grammar.ne';

const compiledGrammar = Grammar.fromCompiled(grammar)

export default {
    data() {
        return {
            mathInput: '',
            parser: {},
            output: ''
        }
    },
    methods: {
        doTheThing() {
            let parser = new Parser(compiledGrammar)
            try {
                this.output = parser.feed(this.mathInput).results
                // debugger;
            } catch (error) {
                this.output = ''
                console.log("Error: ", error)
            }
        }
    }
}
</script>

<style lang="scss" scoped>
input {
    width: 80%;
    line-height: 1em;
    font-size: 2em;
    padding: 0.5em;
}
</style>
