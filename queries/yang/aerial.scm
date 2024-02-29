(statement
  (statement_keyword) @_keyword
  (argument) @name
  (#match? @_keyword "^grouping$")
  (#gsub! @name "^" "grouping ")
  (#set! "kind" "Function")) @symbol

(statement
  (statement_keyword) @_keyword
  (argument) @name
  (#match? @_keyword "^augment$")
  (#gsub! @name "^" "augment ")
  (#set! "kind" "Namespace")) @symbol

(statement
  (statement_keyword) @_keyword
  (argument) @name
  (#match? @_keyword "^list$")
  (#gsub! @name "^" "list ")
  (#set! "kind" "Enum")) @symbol

(statement
  (statement_keyword) @_keyword
  (argument) @name
  (#match? @_keyword "^container$")
  (#gsub! @name "^" "container ")
  (#set! "kind" "Class")) @symbol
