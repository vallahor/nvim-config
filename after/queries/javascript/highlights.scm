; extends
[
 "default"
 "export"
 "async"
 "await"
 "=>"
] @keyword.js

[
 "as"
] @operator

; (jsx_opening_element (identifier) @tag)
; (jsx_closing_element (identifier) @tag)
; (jsx_self_closing_element (identifier) @tag)
; (jsx_attribute (property_identifier) @tag.attribute)

; (import_statement
;   (import_clause
;     (named_imports
;       (import_specifier
;         (identifier) @literal))))
;
; (import_statement
;   (import_clause
;     (identifier) @literal))

