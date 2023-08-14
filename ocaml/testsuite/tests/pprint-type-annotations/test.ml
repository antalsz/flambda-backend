(* TEST
   flags = "-dsource -w -unused-var"
   * expect
*)

(* Useful stuff for later *)
module type T = sig end;;

module Sub_int : sig
  type t = private int;;
  val make : int -> t
end = struct
  type t = int
  let make x = x
end;;

[%%expect{|

module type T  = sig  end;;
module type T = sig end

module Sub_int : sig type t = private int val make : int -> t end =
  struct type t = int
         let make x = x end ;;
module Sub_int : sig type t = private int val make : int -> t end
|}];;

(* Tests *)

let test_lhs : int = 42;;
[%%expect{|

let test_lhs : int = 42;;
val test_lhs : int = 42
|}];;

let test_rhs = (42 : int);;
[%%expect{|

let test_rhs = (42 : int);;
val test_rhs : int = 42
|}];;

let test_packed_lhs : (module T) = (module Int);;
[%%expect{|

let test_packed_lhs : (module T) = (module Int);;
val test_packed_lhs : (module T) = <module>
|}];;

let test_packed_rhs = (module Int : T);;
[%%expect{|

let test_packed_rhs = ((module Int) : (module T));;
val test_packed_rhs : (module T) = <module>
|}];;

let test_fun_lhs x : int = x + 42;;
[%%expect{|

let test_fun_lhs x = (x + 42 : int);;
val test_fun_lhs : int -> int = <fun>
|}];;

let test_fun_rhs x = (x + 42 : int);;
[%%expect{|

let test_fun_rhs x = (x + 42 : int);;
val test_fun_rhs : int -> int = <fun>
|}];;

let test_coerce_from_to_lhs : Sub_int.t :> int = Sub_int.make 42;;
[%%expect{|

let test_coerce_from_to_lhs : int = (Sub_int.make 42 : Sub_int.t  :> int);;
val test_coerce_from_to_lhs : int = 42
|}];;

let test_coerce_from_to_rhs = (Sub_int.make 42 : Sub_int.t :> int);;
[%%expect{|

let test_coerce_from_to_rhs = (Sub_int.make 42 : Sub_int.t  :> int);;
val test_coerce_from_to_rhs : int = 42
|}];;

let test_coerce_to_lhs :> int = Sub_int.make 42;;
[%%expect{|

let test_coerce_to_lhs : int = (Sub_int.make 42 :> int);;
val test_coerce_to_lhs : int = 42
|}];;

let test_coerce_to_rhs = (Sub_int.make 42 :> int);;
[%%expect{|

let test_coerce_to_rhs = (Sub_int.make 42 :> int);;
val test_coerce_to_rhs : int = 42
|}];;

let test_fun_coerce_from_to_lhs x : Sub_int.t :> int = Sub_int.make (x + 42);;
[%%expect{|

let test_fun_coerce_from_to_lhs x =
  (Sub_int.make (x + 42) : Sub_int.t  :> int);;
val test_fun_coerce_from_to_lhs : int -> int = <fun>
|}];;

let test_fun_coerce_from_to_rhs x = (Sub_int.make (x + 42) : Sub_int.t :> int);;
[%%expect{|

let test_fun_coerce_from_to_rhs x =
  (Sub_int.make (x + 42) : Sub_int.t  :> int);;
val test_fun_coerce_from_to_rhs : int -> int = <fun>
|}];;

let test_fun_coerce_to_lhs x :> int = Sub_int.make (42 + x);;
[%%expect{|

let test_fun_coerce_to_lhs x = (Sub_int.make (42 + x) :> int);;
val test_fun_coerce_to_lhs : int -> int = <fun>
|}];;

let test_fun_coerce_to_rhs x = (Sub_int.make (42 + x) :> int);;
[%%expect{|

let test_fun_coerce_to_rhs x = (Sub_int.make (42 + x) :> int);;
val test_fun_coerce_to_rhs : int -> int = <fun>
|}];;

let test_both : int = (42 : int);;
[%%expect{|

let test_both : int = (42 : int);;
val test_both : int = 42
|}];;

let test_fun_both x : int = (x + 42 : int);;
[%%expect{|

let test_fun_both x = ((x + 42 : int) : int);;
val test_fun_both : int -> int = <fun>
|}];;

let test_double_fun_lhs x y : int -> int = fun z -> x + y + z;;
[%%expect{|

let test_double_fun_lhs x y = (fun z -> (x + y) + z : int -> int);;
val test_double_fun_lhs : int -> int -> int -> int = <fun>
|}];;

let test_double_fun_rhs x y = ((fun z -> x + y + z) : int -> int);;
[%%expect{|

let test_double_fun_rhs x y = (fun z -> (x + y) + z : int -> int);;
val test_double_fun_rhs : int -> int -> int -> int = <fun>
|}];;

let local_ test_local_lhs : int =
  42
in ();;
[%%expect{|

;;let local_ test_local_lhs : int = 42 in ();;
- : unit = ()
|}];;

let local_ test_local_rhs =
  (42 : int)
in ();;
[%%expect{|

;;let local_ test_local_rhs = (42 : int) in ();;
- : unit = ()
|}];;

let local_ test_local_packed_lhs : (module T) =
  (module Int)
in ();;
[%%expect{|

;;let local_ test_local_packed_lhs : (module T) = (module Int) in ();;
- : unit = ()
|}];;

let local_ test_local_packed_rhs =
  (module Int : T)
in ();;
[%%expect{|

;;let local_ test_local_packed_rhs = ((module Int) : (module T)) in ();;
- : unit = ()
|}];;

let local_ test_local_fun_lhs x : int =
  x + 42
in ();;
[%%expect{|

;;let local_ test_local_fun_lhs x = (x + 42 : int) in ();;
- : unit = ()
|}];;

let local_ test_local_fun_rhs x =
  (x + 42 : int)
in ();;
[%%expect{|

;;let local_ test_local_fun_rhs x = (x + 42 : int) in ();;
- : unit = ()
|}];;

let local_ test_local_coerce_from_to_lhs : Sub_int.t :> int =
  Sub_int.make 42
in ();;
[%%expect{|

;;let local_ test_local_coerce_from_to_lhs : int =
    (Sub_int.make 42 : Sub_int.t  :> int) in
  ();;
- : unit = ()
|}];;

let local_ test_local_coerce_from_to_rhs =
  (Sub_int.make 42 : Sub_int.t :> int)
in ();;
[%%expect{|

;;let local_ test_local_coerce_from_to_rhs =
    (Sub_int.make 42 : Sub_int.t  :> int) in
  ();;
- : unit = ()
|}];;

let local_ test_local_coerce_to_lhs :> int =
  Sub_int.make 42
in ();;
[%%expect{|

;;let local_ test_local_coerce_to_lhs : int = (Sub_int.make 42 :> int) in ();;
- : unit = ()
|}];;

let local_ test_local_coerce_to_rhs =
  (Sub_int.make 42 :> int)
in ();;
[%%expect{|

;;let local_ test_local_coerce_to_rhs = (Sub_int.make 42 :> int) in ();;
- : unit = ()
|}];;

let local_ test_local_fun_coerce_from_to_lhs x : Sub_int.t :> int =
  Sub_int.make (x + 42)
in ();;
[%%expect{|

;;let local_ test_local_fun_coerce_from_to_lhs x =
    (Sub_int.make (x + 42) : Sub_int.t  :> int) in
  ();;
- : unit = ()
|}];;

let local_ test_local_fun_coerce_from_to_rhs x =
  (Sub_int.make (x + 42) : Sub_int.t :> int)
in ();;
[%%expect{|

;;let local_ test_local_fun_coerce_from_to_rhs x =
    (Sub_int.make (x + 42) : Sub_int.t  :> int) in
  ();;
- : unit = ()
|}];;

let local_ test_local_fun_coerce_to_lhs x :> int =
  Sub_int.make (42 + x)
in ();;
[%%expect{|

;;let local_ test_local_fun_coerce_to_lhs x = (Sub_int.make (42 + x) :> int) in
  ();;
- : unit = ()
|}];;

let local_ test_local_fun_coerce_to_rhs x =
  (Sub_int.make (42 + x) :> int)
in ();;
[%%expect{|

;;let local_ test_local_fun_coerce_to_rhs x = (Sub_int.make (42 + x) :> int) in
  ();;
- : unit = ()
|}];;

let local_ test_local_both : int =
  (42 : int)
in ();;
[%%expect{|

;;let local_ test_local_both : int = (42 : int) in ();;
- : unit = ()
|}];;

let local_ test_local_fun_both x : int =
  (x + 42 : int)
in ();;
[%%expect{|

;;let local_ test_local_fun_both x = ((x + 42 : int) : int) in ();;
- : unit = ()
|}];;

let local_ test_local_double_fun_lhs x y : int -> int =
  fun z -> x + y + z
in ();;
[%%expect{|

;;let local_ test_local_double_fun_lhs x y =
    (fun z -> (x + y) + z : int -> int) in
  ();;
- : unit = ()
|}];;

let local_ test_local_double_fun_rhs x y =
  ((fun z -> x + y + z) : int -> int)
in ();;
[%%expect{|

;;let local_ test_local_double_fun_rhs x y =
    (fun z -> (x + y) + z : int -> int) in
  ();;
- : unit = ()
|}];;
