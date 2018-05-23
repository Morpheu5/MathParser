@{%
const greekLetterMap = { "alpha": "α", "beta": "β", "gamma": "γ", "delta": "δ", "epsilon": "ε", "varepsilon": "ε", "zeta": "ζ", "eta": "η", "theta": "θ", "iota": "ι", "kappa": "κ", "lambda": "λ", "mu": "μ", "nu": "ν", "xi": "ξ", "omicron": "ο", "pi": "π", "rho": "ρ", "sigma": "σ", "tau": "τ", "upsilon": "υ", "phi": "ϕ", "chi": "χ", "psi": "ψ", "omega": "ω", "Gamma": "Γ", "Delta": "Δ", "Theta": "Θ", "Lambda": "Λ", "Xi": "Ξ", "Pi": "Π", "Sigma": "Σ", "Upsilon": "Υ", "Phi": "Φ", "Psi": "Ψ", "Omega": "Ω" }

const moo = require("moo");
const lexer = moo.compile({
	Fn: ['cos', 'sin', 'tan',
         'cosec', 'sec', 'cot',
         'arccos', 'arcsin', 'arctan',
         'arccosec', 'arcsec', 'arccot',
         'cosh', 'sinh', 'tanh', 'cosech', 'sech', 'coth',
         'arccosh', 'arcsinh', 'arctanh', 'arccosech', 'arcsech', 'arccoth',
         'log', 'ln',
         ],
    Radix: 'sqrt',
    Lparen: '(',
    Rparen: ')',
    PlusMinus: /[+-]/,
    Pow: ['^', '**'],
    Mult: ['*', ' '],
    Div: '/',
    c: /./
});
%}
@lexer lexer

main => _ AS _      {% (d) => { return {...d[1], position: { x: 200, y: 200 } } } %}

# Parentheses
P -> %Lparen _ AS _ %Rparen {% function(d) { return { type:'Brackets', properties: { type: "round" }, children: { argument: d[2] } } } %}
    | N             {% id %}
    | FN            {% id %}
    | SY            {% id %}

# Exponents
@{%
const processExponent = (d) => {
    let base = d[0]
    base.children = {...base.children, superscript: d[4] }
    return base
}
%}
E -> P _ %Pow _ E    {% processExponent %}
   | P              {% id %}

# Multiplication and division
@{%
const processMultiplication = (d) => {
    let left = d[0]
    let r = left
    // The negated condition in brackets is a horrible botch-up to substitute Functions previously parsed as Symbols. Ugh.
    while (r.children.right && !(d[4].type == 'Fn' && r.children.right.properties.letter == d[4].properties.name)) {
        r = r.children.right
    }
    r.children = {...r.children, right: d[4] }
    return left
}
const processFraction = (d) => {
    return {
        type: "Fraction",
        children: {
            numerator: d[0],
            denominator: d[4]
        }
    }
}
%}
MD -> MD _ %Mult _ E  {% processMultiplication %}
    | MD _ %Div  _ E  {% processFraction %}
    | E               {% id %}

# Addition and subtraction
@{%
const processBinaryOp = (d) => {
    let left = d[0]
    let r = {
        type: "BinaryOperation",
        properties: { operation: d[2].text },
        children: { right: d[4] }
    }
    if (left.children) {
        left.children.right = r
    } else {
        left.children = { right: r }
    }
    return left
}
%}
AS -> AS _ %PlusMinus _ MD {% processBinaryOp %}
    | MD                   {% id %}

# Functions
@{%
const processFn = (d) => {
    let r = {
        type: "Fn",
        properties: {
            name: d[0].text
        }
    }
    if (null !== d[3]) {
        r.children = { argument: d[3] }
    }
    return r
}
%}
FN -> %Fn    %Lparen _ AS _ %Rparen     {% processFn %}
    | %Radix %Lparen _ AS _ %Rparen  {% (d) => { return { type: "Radix", children: { argument: d[3] } } } %}

# Symbols (letters)
SY -> [a-zA-Z]:+                 {% (d) => { return { type: "Symbol", properties: { letter: greekLetterMap[d[0].join("")] || d[0].join("") }, children: { } } } %}
    | SY "_" [a-zA-Z0-9]:+       {% (d) => { return { ...d[0], children: { subscript: { type: "Symbol", properties: { letter: d[2].join("") } } } } } %}

# Numbers (integers only)
N -> [0-9]:+        {% (d) => { return { type: 'Num', properties: { significand: d[0].join("") }, children: { } } } %}

_ -> [\s]:*         {% (d) => null %}