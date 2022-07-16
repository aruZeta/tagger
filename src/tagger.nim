import macros

#[
Actually only supports writing single-level tags and static content
(no variables, proc calls, etc)
]#

type
  Tag = ref object
    name: string
    params: string
    case closed: bool
    of true:
      content: string
    of false:
      discard

proc newTag(closed: bool): Tag =
  Tag(closed: closed)

proc `$`(tag: Tag): string =
  result = "<" & tag.name & tag.params
  if tag.closed:
    result.add(">" & tag.content & "</" & tag.name & ">")
  else:
    result.add("/>")

proc fillFields(tag: Tag, fields: NimNode) =
  for field in fields:
    case field.kind
    of nnkAsgn:
      tag.params.add " " & field[0].strVal & "=\"" & field[1].strVal & "\""
    of nnkCall:
      discard # Needs implementation
    of nnkCharLit..nnkUInt64Lit:
      if tag.closed:
        tag.content.add($field.intVal)
    of nnkFloatLit..nnkFloat64Lit:
      if tag.closed:
        tag.content.add($field.floatVal)
    of nnkStrLit..nnkTripleStrLit, nnkCommentStmt, nnkIdent, nnkSym:
      if tag.closed:
        tag.content.add(field.strVal)
    else:
      discard

template createTagTemplate(macroName: untyped,
                           tagName: string,
                           closed: bool = true
                          ): untyped =
  macro `macroName`(fields: untyped): untyped =
    let tag = newTag(closed)
    tag.name = tagName
    fillFields(tag, fields)
    result = newStrLitNode($tag)

macro createTag*(name: untyped, closed: bool = true): untyped =
  expectKind(name, nnkIdent)
  result = getAst(createTagTemplate(name, name.strVal, closed))
