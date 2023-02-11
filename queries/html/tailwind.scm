; Regular classes
(attribute
  (attribute_name) @_name
    (#eq? @_name "class")
  (quoted_attribute_value
    (attribute_value) @tailwind))

; AlpineJS
(attribute
  (attribute_name) @_name (#match? @_name "^x-transition:[a-z-]*$")
  (quoted_attribute_value
    (attribute_value) @tailwind))
