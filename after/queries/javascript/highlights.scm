[
 "export"
 "async"
 "await"
] @js.keyword

[
 "=>"
] @js.arrow_func

(jsx_opening_element (identifier) @js.opening_element)
(jsx_closing_element (identifier) @js.closing_element)
(jsx_self_closing_element (identifier) @js.self_closing_element)
(jsx_attribute (property_identifier) @js.property_identifier)

(import_statement
  (import_clause 
    (named_imports 
      (import_specifier 
        (identifier) @js.named_import)))) 

(import_statement
  (import_clause 
    (identifier) @js.import))
