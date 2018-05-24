@{%
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
         ]}
    },
    c: /./,
})
%}
@lexer lexer

main -> _ AS _                      {% (d) => { return d[1] } %}

P -> "(" _ AS _ ")"                 {% (d) => { return "(" + d[2] + ")" } %}
   | %Fn "(" _ AS _ ")"             {% (d) => { return d[0].value.toUpperCase() + "(" + d[3] + ")" } %}
   | %Fn "^" NUM "(" _ AS _ ")"     {% (d) => { return d[0].value.toUpperCase() + "(" + d[5] + ")" + "**" + d[2] } %}
   | VAR                            {% id %}
   | NUM                            {% id %}

E -> P _ "^" _ E                    {% (d) => { return d[0] + "**" + d[4] } %}
   | P _ "**" _ E                   {% (d) => { return d[0] + "**" + d[4] } %}
   | P                              {% id %}

MD -> MD _ "*" _ E                  {% (d) => { return d[0] + "*" + d[4] } %}
    # Do we really need to equate ' ' to '*'? Consider that sin^2 (x) -> sin**2*x vs syntax error.
    | MD _ " " _ E                  {% (d) => { return d[0] + "*" + d[4] } %}
    | MD _ "/" _ E                  {% (d) => { return d[0] + "/" + d[4] } %}
    | E                             {% id %}

AS -> AS _ "+" _ MD                 {% (d) => { return d[0] + "+" + d[4] } %}
    | AS _ "-" _ MD                 {% (d) => { return d[0] + "-" + d[4] } %}
    | MD                            {% id %}

VAR -> %Id                          {% (d) => { return d[0].text } %}

NUM -> %Int                         {% (d) => { return d[0].text } %}

_ -> [\s]:*