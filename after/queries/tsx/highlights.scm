; extends
[
 "export"
 "async"
 "await"
 "typeof"
 "keyof"
] @js.keyword

[
  "declare"
  "extends"
] @js.keyword_bold

[
 "=>"
] @js.arrow_func

(jsx_opening_element (identifier) @js.opening_element)
(jsx_closing_element (identifier) @js.closing_element)
(jsx_self_closing_element (identifier) @js.self_closing_element)

(import_statement
  (import_clause
    (named_imports
      (import_specifier
        (identifier) @js.named_import))))

(import_statement
  (import_clause
    (identifier) @js.import))
