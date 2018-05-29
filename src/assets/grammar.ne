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
         },
    },
    c: /./,
})
%}
@lexer lexer

@{%
const processMain = (d) => {
    let main = _.cloneDeep(d[1])
    main.position = {x:0,y:0}
    main.expression = { latex: "", python: "" }
    return main
}

const processBrackets = (d) => {
    let arg = _.cloneDeep(d[2])
    return { type: 'Brackets', properties: { type: 'round' }, children: { argument: arg } }
}

const processFunction = (d) => {
    let arg = _.cloneDeep(d[3])
    return { type: 'Fn', properties: { name: d[0].text }, children: { argument: arg } }
}

const processExponent = (d) => {
    let f = _.cloneDeep(d[0])
    let e = _.cloneDeep(d[4])

    if (f.type === 'Fn') {
        switch (f.properties.name) {
            case 'ln':
                f.properties['allowSubscript'] = false
                return { type: 'Brackets', properties: { type: 'round' }, children: { argument: f, superscript: e } }
            case 'log':
                f.properties['allowSubscript'] = true
                return { type: 'Brackets', properties: { type: 'round' }, children: { argument: f, superscript: e } }
            default:
                f.properties['innerSuperscript'] = e
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
    let r = lhs
    while (r.children.right) {
        r = r.children.right
    }
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

const processIdentifier = (d) => {
    return { type: 'Symbol', properties: { letter: d[0].text }, children: {} }
}

const processNumber = (d) => {
    return { type: 'Num', properties: { significand: d[0].text }, children: {} }
}
%}

### Behold, the Grammar!

main -> _ AS _                      {% processMain %}

P -> "(" _ AS _ ")"                 {% processBrackets %}
   | %Fn "(" _ AS _ ")"             {% processFunction %}
#  | %Fn "^" NUM "(" _ AS _ ")"     {% (d) => { return d[0].value.toUpperCase() + "(" + d[5] + ")" + "**" + d[2] } %}
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