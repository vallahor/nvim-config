; inherits: zig
[
 "="
 "=>"
] @operator

[
 "..."
] @punctuation.delimiter

[
 "|"
] @punctuation.bracket

(array_type
  (identifier) @punctuation.bracket
  (#eq? @punctuation.bracket "_"))

(variable_declaration
  (identifier) @variable
  (#eq? @variable "_"))
