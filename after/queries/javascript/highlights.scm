; inherits: ecma,jsx

[
 "export"
 "async"
 "await"
] @TSExtendKeyword

[
 "=>"
] @TSExtendArrowFunc


(jsx_opening_element (identifier) @TSJSXOpeningElement)
(jsx_closing_element (identifier) @TSJSXClosingElement)
(jsx_self_closing_element (identifier) @TSJSXSelfClosing)

(import_statement
  (import_clause 
    (named_imports 
      (import_specifier 
        (identifier) @TSJSNamedImport)))) 

(import_statement
  (import_clause 
    (identifier) @TSJSImport))

;;; Parameters
(formal_parameters (identifier) @parameter)

(formal_parameters
  (rest_pattern
    (identifier) @parameter))

;; ({ a }) => null
(formal_parameters
  (object_pattern
    (shorthand_property_identifier_pattern) @parameter))

;; ({ a: b }) => null
(formal_parameters
  (object_pattern
    (pair_pattern
      value: (identifier) @parameter)))

;; ([ a ]) => null
(formal_parameters
  (array_pattern
    (identifier) @parameter))

;; a => null
(arrow_function
  parameter: (identifier) @parameter)

;; optional parameters
(formal_parameters
  (assignment_pattern
    left: (identifier) @parameter))
