; inherits: cpp

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

(expression_statement
 (call_expression
  (field_expression
   (field_identifier) @function)))

(expression_statement
 (binary_expression
  (call_expression
   (identifier) @variable)))

(call_expression
 (field_expression
  (field_identifier) @function))

(field_expression
 (call_expression
  (qualified_identifier
   (identifier) @type)))

(expression_statement
 (call_expression
  (identifier) @function))

(expression_statement
 (assignment_expression
  (call_expression
   (identifier) @function)))

(binary_expression
 (call_expression
  (identifier) @function))
