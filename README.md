# MathParser

A parser of math formulas to allow text entry on [Isaac Physics' symbolic editor](https://isaacphysics.org/equality)

This is no more than a demo application. This code will eventually make its way into Isaac Physics.

```bash
npm install
npm run serve
```

Some of the expressions that this can parse right now are

- `x + y`
- `x/y`
- `x/yz -> (x/y)*z`
- `x/-yz -> (x/(-y))*z`
- `t_0`
- `alpha_t0`
- `sin(x)`
- `sin(x)^2`
- `log(x, 10)`
- `ln(x)`
- `log(x, e)`
- `e^(i*omega + phi)`
- `e^ish -> (e^i)*s*h`
- `e^-ish -> (e^(-i))*s*h`
- `Delta x -> ∆*x`
- `Deltax -> ∆x`, not `∆*x`
- `diff(x^2, x)`
- `diff(x^3 * y^2, x, x, y)`
- `diff(x^3 * y^2, x, 2, y)` (equivalent to the one above)

Other features:

- [x] Greek letters to be converted to their Unicode counterparts
- [x] radicals
- [x] (in)equalities
- [x] derivatives
- [x] absolute values
- [ ] differentials, maybe?

For now, enjoy 🙂
