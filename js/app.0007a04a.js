(function(e){function t(t){for(var n,a,p=t[0],i=t[1],c=t[2],u=0,h=[];u<p.length;u++)a=p[u],s[a]&&h.push(s[a][0]),s[a]=0;for(n in i)Object.prototype.hasOwnProperty.call(i,n)&&(e[n]=i[n]);l&&l(t);while(h.length)h.shift()();return o.push.apply(o,c||[]),r()}function r(){for(var e,t=0;t<o.length;t++){for(var r=o[t],n=!0,p=1;p<r.length;p++){var i=r[p];0!==s[i]&&(n=!1)}n&&(o.splice(t--,1),e=a(a.s=r[0]))}return e}var n={},s={1:0},o=[];function a(t){if(n[t])return n[t].exports;var r=n[t]={i:t,l:!1,exports:{}};return e[t].call(r.exports,r,r.exports,a),r.l=!0,r.exports}a.m=e,a.c=n,a.d=function(e,t,r){a.o(e,t)||Object.defineProperty(e,t,{configurable:!1,enumerable:!0,get:r})},a.r=function(e){Object.defineProperty(e,"__esModule",{value:!0})},a.n=function(e){var t=e&&e.__esModule?function(){return e["default"]}:function(){return e};return a.d(t,"a",t),t},a.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},a.p="/MathParser/";var p=window["webpackJsonp"]=window["webpackJsonp"]||[],i=p.push.bind(p);p.push=t,p=p.slice();for(var c=0;c<p.length;c++)t(p[c]);var l=i;o.push([2,0]),r()})({"00LD":function(e,t,r){},2:function(e,t,r){e.exports=r("Vtdi")},G7Gf:function(e,t,r){},HbVl:function(e,t,r){"use strict";var n=r("G7Gf"),s=r.n(n);s.a},RQWL:function(e,t,r){(function(){function t(e){return e[0]}const n=r("LvDl"),s={alpha:"α",beta:"β",gamma:"γ",delta:"δ",epsilon:"ε",varepsilon:"ε",zeta:"ζ",eta:"η",theta:"θ",iota:"ι",kappa:"κ",lambda:"λ",mu:"μ",nu:"ν",xi:"ξ",omicron:"ο",pi:"π",rho:"ρ",sigma:"σ",tau:"τ",upsilon:"υ",phi:"ϕ",chi:"χ",psi:"ψ",omega:"ω",Gamma:"Γ",Delta:"Δ",Theta:"Θ",Lambda:"Λ",Xi:"Ξ",Pi:"Π",Sigma:"Σ",Upsilon:"Υ",Phi:"Φ",Psi:"Ψ",Omega:"Ω"},o=r("D4Uk"),a=o.compile({Int:/[0-9]+/,Id:{match:/[a-zA-Z]+(?:_[a-zA-Z0-9]+)?/,keywords:{Fn:["cos","sin","tan","cosec","sec","cot","arccos","arcsin","arctan","arccosec","arcsec","arccot","cosh","sinh","tanh","cosech","sech","coth","arccosh","arcsinh","arctanh","arccosech","arcsech","arccoth","log","ln"],Radix:["sqrt"]}},Rel:["=","==","<","<=",">",">="],c:/./});let p=null;try{p=window}catch(e){p={innerWidth:800,innerHeight:600}}const i=e=>{let t=e;while(t.children.right)t=t.children.right;return t},c=e=>{let t=n.cloneDeep(e[1]);return t.position={x:p.innerWidth/4,y:p.innerHeight/3},t.expression={latex:"",python:""},t},l=e=>{let t=n.cloneDeep(e[1]),r=n.cloneDeep(e[5]),s="=="===e[3].text?"=":e[3].text,o={type:"Relation",properties:{relation:s},children:{rhs:r}},a=i(t);return a.children["right"]=o,{...t,position:{x:p.innerWidth/4,y:p.innerHeight/3},expression:{latex:"",python:""}}},u=e=>{let t=n.cloneDeep(e[2]);return{type:"Brackets",properties:{type:"round"},children:{argument:t}}},h=e=>{let t=n.cloneDeep(e[3]);return{type:"Fn",properties:{name:e[0].text},children:{argument:t}}},m=e=>{let t=n.cloneDeep(e[5]),r=n.cloneDeep(e[2]);return{type:"Fn",properties:{name:e[0].text},children:{innerSuperscript:r,argument:t}}},d=e=>{let t=n.cloneDeep(e[3]);return{type:"Radix",children:{argument:t}}},y=e=>{let t=n.cloneDeep(e[0]),r=n.cloneDeep(e[4]);if("Fn"!==t.type)return t.children["superscript"]=r,t;switch(t.properties.name){case"ln":return t.properties["allowSubscript"]=!1,{type:"Brackets",properties:{type:"round"},children:{argument:t,superscript:r}};case"log":return t.properties["allowSubscript"]=!0,{type:"Brackets",properties:{type:"round"},children:{argument:t,superscript:r}};default:return t.children["innerSuperscript"]?{type:"Brackets",properties:{type:"round"},children:{argument:t,superscript:r}}:(t.children["innerSuperscript"]=r,t)}},_=e=>{let t=n.cloneDeep(e[0]),r=n.cloneDeep(e[4]),s=i(t);return s.children["right"]=r,t},f=e=>{return{type:"Fraction",children:{numerator:n.cloneDeep(e[0]),denominator:n.cloneDeep(e[4])}}},b=e=>{let t=n.cloneDeep(e[0]),r=n.cloneDeep(e[4]),s=i(t);return s.children["right"]={type:"BinaryOperation",properties:{operation:e[2].text},children:{right:r}},t},g=e=>{let t=n.map(e.split(""),e=>{return/[0-9]/.test(e)?x([{text:e}]):{type:"Symbol",properties:{letter:e},children:{}}}),r=n.reduceRight(t,(e,t)=>{return t.children["right"]=e,t});return r},v=e=>{let t=new RegExp(n.keys(s).join("|"),"g"),r=e[0].text.replace(t,e=>s[e]||e).split("_"),o=g(r[0]);if(r.length>1){let e=g(r[1]),t=i(o);t.children["subscript"]=e}return o},x=e=>{return{type:"Num",properties:{significand:e[0].text},children:{}}};var D={Lexer:a,ParserRules:[{name:"main",symbols:["_","AS","_"],postprocess:c},{name:"main",symbols:["_","AS","_",a.has("Rel")?{type:"Rel"}:Rel,"_","AS","_"],postprocess:l},{name:"P",symbols:[{literal:"("},"_","AS","_",{literal:")"}],postprocess:u},{name:"P",symbols:[a.has("Fn")?{type:"Fn"}:Fn,{literal:"("},"_","AS","_",{literal:")"}],postprocess:h},{name:"P",symbols:[a.has("Fn")?{type:"Fn"}:Fn,{literal:"^"},"NUM",{literal:"("},"_","AS","_",{literal:")"}],postprocess:m},{name:"P",symbols:[a.has("Radix")?{type:"Radix"}:Radix,{literal:"("},"_","AS","_",{literal:")"}],postprocess:d},{name:"P",symbols:["VAR"],postprocess:t},{name:"P",symbols:["NUM"],postprocess:t},{name:"E",symbols:["P","_",{literal:"^"},"_","E"],postprocess:y},{name:"E",symbols:["P"],postprocess:t},{name:"MD",symbols:["MD","_",{literal:"*"},"_","E"],postprocess:_},{name:"MD",symbols:["MD","_",{literal:" "},"_","E"],postprocess:_},{name:"MD",symbols:["MD","_",{literal:"/"},"_","E"],postprocess:f},{name:"MD",symbols:["E"],postprocess:t},{name:"AS",symbols:["AS","_",{literal:"+"},"_","MD"],postprocess:b},{name:"AS",symbols:["AS","_",{literal:"-"},"_","MD"],postprocess:b},{name:"AS",symbols:["MD"],postprocess:t},{name:"VAR",symbols:[a.has("Id")?{type:"Id"}:Id],postprocess:v},{name:"NUM",symbols:[a.has("Int")?{type:"Int"}:Int],postprocess:x},{name:"_$ebnf$1",symbols:[]},{name:"_$ebnf$1",symbols:["_$ebnf$1",/[\s]/],postprocess:function(e){return e[0].concat([e[1]])}},{name:"_",symbols:["_$ebnf$1"]}],ParserStart:"main"};"undefined"!==typeof e&&"undefined"!==typeof e.exports?e.exports=D:window.grammar=D})()},Vtdi:function(e,t,r){"use strict";r.r(t);r("VRzm");var n=r("Kw5r"),s=function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("div",{attrs:{id:"app"}},[r("MathInput")],1)},o=[],a=function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("div",{attrs:{id:"container"}},[e._m(0),e._v(" "),r("p",[e._v("Type some maths, check that the tree gets generated correctly.")]),e._v(" "),r("input",{directives:[{name:"model",rawName:"v-model",value:e.mathInput,expression:"mathInput"}],attrs:{placeholder:"Your math goes here",name:"mathstring"},domProps:{value:e.mathInput},on:{keyup:e.doTheThing,input:function(t){t.target.composing||(e.mathInput=t.target.value)}}}),e._v(" "),r("pre",[r("strong",[e._v("Input")]),e._v(":"),r("br"),e._v("       "+e._s(e.mathInput))]),e._v(" "),r("pre",[e._v("---"),r("br"),e._v(e._s(e.parser.lexer))]),e._v(" "),r("pre",[r("strong",[e._v("Output")]),e._v(":"),r("br"),e._v(e._s(e.output))])])},p=[function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("h1",[e._v("Symbolic math parser for "),r("a",{attrs:{href:"https://isaacphysics.org"}},[e._v("Isaac Physics")])])}],i=r("rFXv"),c=r("RQWL"),l=r.n(c),u=i["Grammar"].fromCompiled(l.a),h={data:function(){return{mathInput:"",parser:{},output:""}},methods:{doTheThing:function(){var e=new i["Parser"](u);try{this.output=e.feed(this.mathInput).results}catch(e){this.output="Some error occurred: ".concat(e)}}}},m=h,d=(r("HbVl"),r("KHd+")),y=Object(d["a"])(m,a,p,!1,null,"7ca18021",null),_=y.exports,f={name:"app",components:{MathInput:_}},b=f,g=(r("ZL7j"),Object(d["a"])(b,s,o,!1,null,null,null)),v=g.exports;n["a"].config.productionTip=!1,new n["a"]({render:function(e){return e(v)}}).$mount("#app")},ZL7j:function(e,t,r){"use strict";var n=r("00LD"),s=r.n(n);s.a}});
//# sourceMappingURL=app.0007a04a.js.map