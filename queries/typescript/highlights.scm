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

(import_statement
  (import_clause
    (named_imports
      (import_specifier
        (identifier) @js.named_import))))

(import_statement
  (import_clause
    (identifier) @js.import))
