[
 "export"
 "async"
 "await"
] @TSExtendKeyword

[
 "=>"
] @TSExtendArrowFunc

(import_statement
   (import_clause 
     (named_imports 
       (import_specifier 
         (identifier) @TSJSNamedImport)))) 

 (import_statement
   (import_clause 
     (identifier) @TSJSImport))

