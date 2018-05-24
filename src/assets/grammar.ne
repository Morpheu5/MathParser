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
    d[1].position = {x:0,y:0}
    d[1].expression = { latex: "", python: "" }
    return d[1]
}

const processBrackets = (d) => {
    return { type: 'Brackets', properties: { type: 'round' }, children: { argument: d[2] } }
}

const processFunction = (d) => {
    return { type: 'Fn', properties: { name: d[0].text }, children: { argument: d[3] } }
}

const processExponent = (d) => {
    if (d[0].type === 'Fn') {
        switch (d[0].properties.name) {
            case 'ln':
                d[0].properties['allowSubscript'] = false
                return { type: 'Brackets', properties: { type: 'round' }, children: { argument: d[0], superscript: d[4] } }
            case 'log':
                d[0].properties['allowSubscript'] = true
                return { type: 'Brackets', properties: { type: 'round' }, children: { argument: d[0], superscript: d[4] } }
            default:
                d[0].properties['innerSuperscript'] = d[4]
                return d[0]
        }
    } else {
        d[0].children['superscript'] = d[4]
        return d[0]
    }
}

const processMultiplication = (d) => {
    let r = d[0]
    while (r.children.right) {
        r = r.children.right
    }
    // This is a terrifying hack.
    if (r.type !== d[4].type && !_.isEqual(r.properties, d[4].properties)) {
        r.children['right'] = d[4]
    }
    return d[0]
}

const processFraction = (d) => {
    return {
        type: 'Fraction',
        children: {
            numerator: d[0],
            denominator: d[4]
        }
    }
}

const processPlusMinus = (d) => {
    d[0].children['right'] = { type: 'BinaryOperation', properties: { operation: d[2].text }, children: { right: d[4] } }
    return d[0]
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