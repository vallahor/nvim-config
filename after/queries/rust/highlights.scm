; extends

(call_expression
  function: (identifier) @type (#match? @type "^[A-Z][a-z_0-9]*"))

(call_expression
  function: (scoped_identifier
              name: (identifier) @type (#match? @type "^[A-Z][a-z_0-9]*")))

(let_declaration
  value: (scoped_identifier
           name: (identifier) @constant))

(enum_item
  body: (enum_variant_list
          (enum_variant
            name: (identifier) @type
            body: _)))

(use_list
  (identifier) @namespace (#match? @namespace "^[a-z]"))

(use_declaration
  argument: (identifier) @namespace (#match? @namespace "^[a-z]"))

(use_declaration
  argument: (scoped_identifier
              name: (identifier) @namespace (#match? @namespace "^[a-z]")))
