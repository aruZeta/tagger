# Libs are actually defined under tagger/

#[ tagger/tag:
   Provides a Tag type with the fields name, params and content (if closed)
   Provides procs to create new Tags, add params to it, parse params into a
   string, and convert a Tag type into a string.
]#

#[ tagger/tagMacro:
   Provides a macro to create tag macros to easily write xml/html structures,
   you can provide them paramaters and contents (data inside the tag, like
   children tags or actual text). You can use both static data, literal values
   (123, "12"), and runtime data, like a variable or a proc call (foo, bar()).
]#
