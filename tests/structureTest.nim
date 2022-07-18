import macros

#[
Since some of the element names are nim keywords, such div, the suffix `h` will
be used (`h` from `html`), so div will be hdiv.
]#

dumpTree:
  html:
    head:
      title: "HTML ast structure test"
    body:
      hdiv:
        p: "Paragraph test"
        p:
          class = "class-test"
          "Parapgraph with class test"
        p:
          "We can use multiple strings"
          " which will be concatenated,"
          " and also numbers: " 23
          ", like echo() does"
      hdiv:
        "We can also use variables: "
        someVar
        " and proc calls: "
        procCall()

# This generates the next AST
#[
StmtList
  Call
    Ident "html"
    StmtList
      Call
        Ident "head"
        StmtList
          Call
            Ident "title"
            StmtList
              StrLit "HTML ast structure test"
      Call
        Ident "body"
        StmtList
          Call
            Ident "hdiv"
            StmtList
              Call
                Ident "p"
                StmtList
                  StrLit "Paragraph test"
              Call
                Ident "p"
                StmtList
                  Asgn
                    Ident "class"
                    StrLit "class-test"
                  StrLit "Parapgraph with class test"
              Call
                Ident "p"
                StmtList
                  StrLit "We can use multiple strings"
                  StrLit " which will be concatenated,"
                  Command
                    StrLit " and also numbers: "
                    IntLit 23
                  StrLit ", like echo() does"
          Call
            Ident "hdiv"
            StmtList
              StrLit "We can also use variables: "
              Ident "someVar"
              StrLit "And proc calls: "
              Call
                Ident "procCall"
]#

#[
As you can see, a tag is a just a Call where it's Ident is the name of the tag
and it's params and content are inside a StmtList, params will be Asgn and the
rest will content.

What the macro of a tag should return is an AST with the concatenated literals
where possible, and leave the calls and variables as they are, so they can be
parsed if they are a macro by the compiler, and if they are not, like procs or
variables, the compiler can't do anything with them if they can just be known
at runtime.

So for this:
p:
  id = "test"
  "Some text: "
  someVar

We could return a AST like this one:
Call
  Ident "join"
  Ident "<p id=\"test\">Some text: "
  Ident someVar
  Ident "</p>"

Where, when possible, we join the known in compiletime stuff, like in the first
ident, and leave in a separate one the variables and calls.
]#
