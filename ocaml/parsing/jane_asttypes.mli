(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*               Antal Spector-Zabusky, Jane Street, New York             *)
(*                                                                        *)
(*   Copyright 2023 Jane Street Group LLC                                 *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(** Auxiliary Jane Street extensions to AST types used by parsetree and
    typedtree.

  {b Warning:} this module is unstable and part of
  {{!Compiler_libs}compiler-libs}.

*)

open Asttypes

type global_flag =
  | Global
  | Nothing

(* constant layouts are parsed as layout annotations, and also used
   in the type checker as already-inferred (i.e. non-variable) layouts *)
type const_layout =
  | Any
  | Value
  | Void
  | Immediate64
  | Immediate
  | Float64

type layout_annotation = const_layout loc
