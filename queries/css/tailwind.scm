(
    (postcss_statement
        .(at_keyword) @_keyword (#eq? @_keyword "@apply")
        ((plain_value).(plain_value)*.)
    ) @tailwind
    (#offset! @tailwind 0 8 0 -2)
)
