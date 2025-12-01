
; Highlight text chunks in "Documentation" settings with @spell

(setting_statement
  name: (setting_name) @_name
  (arguments
    (argument
      (text_chunk) @spell))
  (#match? @_name "^Documentation$"))

(setting_statement
  name: (setting_name) @_name
  (arguments
    (continuation
      (argument
        (text_chunk) @spell)))
  (#match? @_name "^Documentation$"))

(keyword_setting
  name: (keyword_setting_name) @_name
  (arguments
    (argument
      (text_chunk) @spell))
  (#match? @_name "^Documentation$"))

(keyword_setting
  name: (keyword_setting_name) @_name
  (arguments
    (continuation
      (argument
        (text_chunk) @spell)))
  (#match? @_name "^Documentation$"))

(test_case_setting
  name: (test_case_setting_name) @_name
  (arguments
    (argument
      (text_chunk) @spell))
  (#match? @_name "^Documentation$"))

(test_case_setting
  name: (test_case_setting_name) @_name
  (arguments
    (continuation
      (argument
        (text_chunk) @spell)))
  (#match? @_name "^Documentation$"))
