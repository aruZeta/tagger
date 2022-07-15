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
                  StrLit " and also numbers: "
                  IntLit 23
                  StrLit ", like echo() does"
]#

#[
As you can see, the content inside a tag is anything inside the StmtList which
is not a Asgn while Call will need to be evaluated.

Asgn will be treated as a parameter of the tag, there won't be a checking
whether it is an accepted parameter of that tag or not, or at least for now
(may be convenient for generating xml which uses a xst).

Inside the Asgn we have:
- A Ident, which is the name of the parameter
- A StrLit, which is a string with its value (only accepts strings)

Call is just another tag.

Inside a Call we have:
- A Ident, which is the name of the tag
- A StmtList, which is the content of the tag with what was specified above

Each of the Call will need to be a macro itself, so in order to generate
them another macro will be used such: generateTag(name = "html", closed = true)
]#
