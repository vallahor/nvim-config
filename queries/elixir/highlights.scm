; inherits: elixir

[
 "@"
] @Punctuation.special

; Documentation
(unary_operator
  operator: "@"
  operand: (call
    target: ((identifier) @_identifier
      (#any-of? @_identifier "moduledoc" "typedoc" "shortdoc" "doc")) @constant
    (arguments
      [
        (string)
        (boolean)
        (charlist)
        (sigil
          "~" @comment.documentation
          (sigil_name) @comment.documentation
          quoted_start: _ @comment.documentation
          (quoted_content) @comment.documentation
          quoted_end: _ @comment.documentation)
      ] @comment.documentation))) @Punctuation.special
