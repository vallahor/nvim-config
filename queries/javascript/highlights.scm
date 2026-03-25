; inherits: javascript

(labeled_statement
  label: (statement_identifier) @variable.parameter)

(labeled_statement
  body: (expression_statement
    (identifier) @type))
