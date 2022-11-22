; extends
[
 "export"
 "async"
 "await"
 "typeof"
 "keyof"
 "declare"
 "extends"
 "=>"
] @keyword

[
 "as"
] @operator

; (import_statement
;   (import_clause
;     (named_imports
;       (import_specifier
;         (identifier) @literal))))
;
; (import_statement
;   (import_clause
;     (identifier) @literal))
