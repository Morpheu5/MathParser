@{%
const _ = require("lodash")
const greekLetterMap = { "alpha": "α", "beta": "β", "gamma": "γ", "delta": "δ", "epsilon": "ε", "varepsilon": "ε", "zeta": "ζ", "eta": "η", "theta": "θ", "iota": "ι", "kappa": "κ", "lambda": "λ", "mu": "μ", "nu": "ν", "xi": "ξ", "omicron": "ο", "pi": "π", "rho": "ρ", "sigma": "σ", "tau": "τ", "upsilon": "υ", "phi": "ϕ", "chi": "χ", "psi": "ψ", "omega": "ω", "Gamma": "Γ", "Delta": "Δ", "Theta": "Θ", "Lambda": "Λ", "Xi": "Ξ", "Pi": "Π", "Sigma": "Σ", "Upsilon": "Υ", "Phi": "Φ", "Psi": "Ψ", "Omega": "Ω" }
const moo = require("moo");
const lexer = moo.compile({
    Int: /[0-9]+/,
    Id: { match: /[a-zA-Z]+(?:_[a-zA-Z0-9]+)?/, keywords: {
	Fn: ['cos', 'sin', 'tan',
         'cosec', 'sec', 'cot',
         'arccos', 'arcsin', 'arctan',
         'arccosec', 'arcsec', 'arccot',
         'cosh', 'sinh', 'tanh', 'cosech', 'sech', 'coth',
         'arccosh', 'arcsinh', 'arctanh', 'arccosech', 'arcsech', 'arccoth',
         'log', 'ln',
         ],
    Radix: ['sqrt'],
         },
    },
    Rel: ['=', '==', '<', '<=', '>', '>='],
    c: /./,
})
%}
@lexer lexer

@{%
let _window = null
try {
    _window = window
} catch (error) {
    _window = { innerWidth: 800, innerHeight: 600 }
}

const _findRightmost = (node) => {
    let n = node
    while (n.children.right) {
        n = n.children.right
    }
    return n
}

const processMain = (d) => {
    let main = _.cloneDeep(d[1])
    main.position = { x: _window.innerWidth/4, y: _window.innerHeight/3 }
    main.expression = { latex: "", python: "" }
    return main
}

const processRelation = (d) => {
    let left = _.cloneDeep(d[1])
    let right = _.cloneDeep(d[5])
    let relText = d[3].text === '==' ? '=' : d[3].text
    let relation = { type: 'Relation', properties: { relation: relText }, children: { right } }
    let r = _findRightmost(left)
    r.children['right'] = relation
    return { ...left, position: { x: _window.innerWidth/4, y: _window.innerHeight/3 }, expression: { latex: "", python: "" } }
}

const processBrackets = (d) => {
    let arg = _.cloneDeep(d[2])
    return { type: 'Brackets', properties: { type: 'round' }, children: { argument: arg } }
}

const processFunction = (d) => {
    let arg = _.cloneDeep(d[3])
    return { type: 'Fn', properties: { name: d[0].text, allowSubscript: d[0].text !== 'ln', innerSuperscript: false }, children: { argument: arg } }
}

const processSpecialTrigFunction = (d) => {
    let arg = _.cloneDeep(d[5])
    let exp = _.cloneDeep(d[2])
    return { type: 'Fn', properties: { name: d[0].text, allowSubscript: false, innerSuperscript: true }, children: { superscript: exp, argument: arg } }
}

const processRadix = (d) => {
    let arg = _.cloneDeep(d[3])
    return { type: 'Radix', children: { argument: arg } }
}

const processExponent = (d) => {
    let f = _.cloneDeep(d[0])
    let e = _.cloneDeep(d[4])

    if (f.type === 'Fn') {
        switch (f.properties.name) {
            case 'ln':
                return { type: 'Brackets', properties: { type: 'round' }, children: { argument: f, superscript: e } }
            case 'log':
                return { type: 'Brackets', properties: { type: 'round' }, children: { argument: f, superscript: e } }
            default:
                f.properties['superscript'] = e
                return f
        }
    } else {
        f.children['superscript'] = e
        return f
    }
}

const processMultiplication = (d) => {
    let lhs = _.cloneDeep(d[0])
    let rhs = _.cloneDeep(d[4])
    let r = _findRightmost(lhs)
    r.children['right'] = rhs
    return lhs
}

const processFraction = (d) => {
    return {
        type: 'Fraction',
        children: {
            numerator: _.cloneDeep(d[0]),
            denominator: _.cloneDeep(d[4])
        }
    }
}

const processPlusMinus = (d) => {
    let lhs = _.cloneDeep(d[0])
    let rhs = _.cloneDeep(d[4])
    lhs.children['right'] = { type: 'BinaryOperation', properties: { operation: d[2].text }, children: { right: rhs } }
    return lhs
}

const _processChainOfLetters = (s) => {
    let symbols = _.map(s.split(''), (letter) => {
        if (/[0-9]/.test(letter)) {
            return processNumber( [ {text:letter} ] )
        } else {
            return { type: 'Symbol', properties: { letter }, children: {} }
        }
    })
    let chain = _.reduceRight(symbols, (a, c) => {
        c.children['right'] = a
        return c
    })
    return chain
}

const processIdentifier = (d) => {
    let rx = new RegExp(_.keys(greekLetterMap).join('|'), 'g')
    let parts = d[0].text.replace(rx, (v) => greekLetterMap[v] || v).split('_')
    let topChain = _processChainOfLetters(parts[0])
    if (parts.length > 1) {
        let chain = _processChainOfLetters(parts[1])
        let r = _findRightmost(topChain)
        r.children['subscript'] = chain
    }
    return topChain
}

const processNumber = (d) => {
    return { type: 'Num', properties: { significand: d[0].text }, children: {} }
}
%}

### Behold, the Grammar!

main -> _ AS _                      {% processMain %}
      | _ AS _ %Rel _ AS _          {% processRelation %}

P -> "(" _ AS _ ")"                 {% processBrackets %}
   | %Fn "(" _ AS _ ")"             {% processFunction %}
   | %Fn "^" NUM "(" _ AS _ ")"     {% processSpecialTrigFunction %}
   | %Radix "(" _ AS _ ")"          {% processRadix %}
   | VAR                            {% id %}
   | NUM                            {% id %}

E -> P _ "^" _ E                    {% processExponent %}
   | P                              {% id %}

# Multiplication and division
MD -> MD _ "*" _ E                  {% processMultiplication %}
    # Do we really need to equate ' ' to '*'? Consider that sin^2 (x) -> sin**2*x vs syntax error.
    | MD _ " " _ E                  {% processMultiplication %}
    | MD _ "/" _ E                  {% processFraction %}
    | E                             {% id %}

AS -> AS _ "+" _ MD                 {% processPlusMinus %}
    | AS _ "-" _ MD                 {% processPlusMinus %}
    | MD                            {% id %}

VAR -> %Id                          {% processIdentifier %}

NUM -> %Int                         {% processNumber %}

_ -> [\s]:*