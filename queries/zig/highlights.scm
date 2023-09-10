; extends
[
 "="
 "=>"
] @operator

;; that can be inferred because of the zig conventions
(
 [
  variable_type_function: (IDENTIFIER)
  field_access: (IDENTIFIER)
  function: (IDENTIFIER)
 ] @type
 (#lua-match? @type "^[A-Z][a-z_0-9]*")
)

(
 [
  variable_type_function: (IDENTIFIER)
 ] @function
 (FnCallArguments)
)

(
 [
  variable_type_function: (IDENTIFIER)
 ] @type
 (FnCallArguments)
 (#lua-match? @type "^[A-Z][a-z_0-9]*")
)

(
 (ContainerField
   (ErrorUnionExpr
     (SuffixExpr
       [
        variable_type_function: (IDENTIFIER)
        ] @constant
       )
     ))
 )

;; @check if it's really necessary (too much color??)
; (
;  [
;   parameter: (IDENTIFIER)
;   variable_type_function: (IDENTIFIER)
;  ] @constant.builtin
;  (#lua-match? @constant.builtin "self")
; )
