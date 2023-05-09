(* TEST
   * flambda
   ** native
   compile_only = "true"
   *** check-ocamlc.opt-output
*)

let f (x[@specialise]) = x
let f (x[@specialize]) = x
let f (x[@specialised]) = x
let f (x[@specialized]) = x
let f (x[@ocaml.specialise]) = x
let f (x[@ocaml.specialize]) = x
let f (x[@ocaml.specialised]) = x
let f (x[@ocaml.specialized]) = x
