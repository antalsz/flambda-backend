(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 1996 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(* Typechecking of type expressions for the core language *)

open Layouts
open Types
open Mode

module TyVarEnv : sig
  (* this is just the subset of [TyVarEnv] that is needed outside
     of [Typetexp]. See the ml file for more. *)

  val reset : unit -> unit
  (** removes all type variables from scope *)

  val with_local_scope : (unit -> 'a) -> 'a
  (** Evaluate in a narrowed type-variable scope *)

  type poly_univars
  val make_poly_univars : string Location.loc list -> poly_univars
    (** A variant of [make_poly_univars_layouts] that gets variables
        without layout annotations *)

  val make_poly_univars_layouts :
    context:(string -> Layout.annotation_context) ->
    (string Location.loc * Jane_asttypes.layout_annotation option) list ->
    poly_univars
    (** remember that a list of strings connotes univars; this must
        always be paired with a [check_poly_univars]. *)

  val check_poly_univars :
     Env.t -> Location.t -> poly_univars -> type_expr list
    (** Verify that the given univars are universally quantified,
       and return the list of variables. The type in which the
       univars are used must be generalised *)

  val instance_poly_univars :
     Env.t -> Location.t -> poly_univars -> type_expr list
    (** Same as [check_poly_univars], but instantiates the resulting
       type scheme (i.e. variables become Tvar rather than Tunivar) *)
end

val valid_tyvar_name : string -> bool

val transl_simple_type:
        Env.t -> ?univars:TyVarEnv.poly_univars -> closed:bool -> Alloc.Const.t
        -> Parsetree.core_type -> Typedtree.core_type
val transl_simple_type_univars:
        Env.t -> Parsetree.core_type -> Typedtree.core_type
val transl_simple_type_delayed
  :  Env.t -> Alloc.Const.t
  -> Parsetree.core_type
  -> Typedtree.core_type * type_expr * (unit -> unit)
        (* Translate a type, but leave type variables unbound. Returns
           the type, an instance of the corresponding type_expr, and a
           function that binds the type variable. *)
val transl_type_scheme:
        Env.t -> Parsetree.core_type -> Typedtree.core_type
val transl_type_param:
  Env.t -> Path.t -> Parsetree.core_type -> Typedtree.core_type
(* the Path.t above is of the type/class whose param we are processing;
   the level defaults to the current level *)

val get_type_param_layout: Path.t -> Parsetree.core_type -> layout
val get_type_param_name: Parsetree.core_type -> string option

val get_alloc_mode : Parsetree.core_type -> Alloc.Const.t

exception Already_bound

type value_loc =
    Tuple | Poly_variant | Package_constraint | Object_field

type sort_loc =
    Fun_arg | Fun_ret

type cannot_quantify_reason
type layout_info
type error =
  | Unbound_type_variable of string * string list
  | No_type_wildcards
  | Undefined_type_constructor of Path.t
  | Type_arity_mismatch of Longident.t * int * int
  | Bound_type_variable of string
  | Recursive_type
  | Unbound_row_variable of Longident.t
  | Type_mismatch of Errortrace.unification_error
  | Alias_type_mismatch of Errortrace.unification_error
  | Present_has_conjunction of string
  | Present_has_no_type of string
  | Constructor_mismatch of type_expr * type_expr
  | Not_a_variant of type_expr
  | Variant_tags of string * string
  | Invalid_variable_name of string
  | Cannot_quantify of string * cannot_quantify_reason
  | Bad_univar_layout of
      { name : string; layout_info : layout_info; inferred_layout : layout }
  | Multiple_constraints_on_type of Longident.t
  | Method_mismatch of string * type_expr * type_expr
  | Opened_object of Path.t option
  | Not_an_object of type_expr
  | Unsupported_extension : _ Language_extension.t -> error
  | Polymorphic_optional_param
  | Non_value of
      {vloc : value_loc; typ : type_expr; err : Layout.Violation.t}
  | Non_sort of
      {vloc : sort_loc; typ : type_expr; err : Layout.Violation.t}
  | Bad_layout_annot of type_expr * Layout.Violation.t

exception Error of Location.t * Env.t * error

val report_error: Env.t -> Format.formatter -> error -> unit

(* Support for first-class modules. *)
val transl_modtype_longident:  (* from Typemod *)
    (Location.t -> Env.t -> Longident.t -> Path.t) ref
val transl_modtype: (* from Typemod *)
    (Env.t -> Parsetree.module_type -> Typedtree.module_type) ref
val create_package_mty:
    Location.t -> Env.t -> Parsetree.package_type ->
    (Longident.t Asttypes.loc * Parsetree.core_type) list *
      Parsetree.module_type
