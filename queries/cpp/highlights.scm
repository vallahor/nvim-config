; extends

(function_definition
 (function_declarator
  (qualified_identifier
   (identifier) @function)))


(call_expression
 (qualified_identifier
  (identifier) @function))

(function_definition
 (reference_declarator
  (function_declarator
   (qualified_identifier
    (identifier) @function))))

(function_definition
 (pointer_declarator
  (function_declarator
   (qualified_identifier
    (identifier) @function))))
