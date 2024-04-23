
(let_expression
  (binding_set
    (binding
      (attrpath) @name
      (#set! "kind" "Variable")) @symbol))

(attrset_expression
  (binding_set
    (binding
      (attrpath) @name
      (#set! "kind" "Key")) @symbol))

(rec_attrset_expression
  (binding_set
    (binding
      (attrpath) @name
      (#set! "kind" "Key")) @symbol))
