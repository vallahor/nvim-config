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
 ] @type
 (#lua-match? @type "^[A-Z][a-z_0-9]*")
)

;; @check if it's really necessary (too much color??)
; (
;  [
;   parameter: (IDENTIFIER)
;   variable_type_function: (IDENTIFIER)
;  ] @type
;  (#lua-match? @type "self")
; )
