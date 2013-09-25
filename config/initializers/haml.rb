Haml::Options.defaults[:escape_html] = true # XSS Protection by default.
Haml::Options.defaults[:attr_wrapper] = '"' # Stop this <a href='...'> madness.

