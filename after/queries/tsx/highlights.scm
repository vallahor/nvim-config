[
 "export"
 "async"
 "await"
] @TSExtendKeyword

[
 "=>"
] @TSExtendArrowFunc

(jsx_opening_element (identifier) @TSJSXOpeningElement)
;; (jsx_closing_element (identifier) @TSJSXClosingElement)
;; (jsx_self_closing_element (identifier) @TSJSXSelfClosing)
;;
(import_statement
   (import_clause 
     (named_imports 
       (import_specifier 
         (identifier) @TSJSNamedImport)))) 

 (import_statement
   (import_clause 
     (identifier) @TSJSImport))

