
(let_expression
  "let" @name
  (#set! "kind" "Namespace")) @symbol

(let_expression
  body: (apply_expression
          function: (_) @name @symbol)
  (#set! "kind" "Object")
  (#prefix! @name "text" "in "))

(let_expression
  (binding_set
    (binding
      (attrpath) @name
      (#set! "kind" "Variable")) @symbol))

(attrset_expression
  (binding_set
    (binding
      (attrpath) @name
      expression: (function_expression)
      (#set! "kind" "Function")) @symbol))

(attrset_expression
  (binding_set
    (binding
      (attrpath) @name
      expression: (_) @_type
      (#not-eq? @_type "function_expression")
      (#set! "kind" "Key")) @symbol))

(rec_attrset_expression
  (binding_set
    (binding
      (attrpath) @name
      (#set! "kind" "Key")) @symbol))
