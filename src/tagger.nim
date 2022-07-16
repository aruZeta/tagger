import macros

proc processFields(fields: NimNode): string =
  var params = ""
  var content = ""

  for field in fields:
    case field.kind
    of nnkAsgn:
      params.add field[0].strVal & "=\"" & field[1].strVal & "\""
    of nnkCall:
      discard # Needs implementation
    of nnkCharLit..nnkUInt64Lit:
      content.add($field.intVal)
    of nnkFloatLit..nnkFloat64Lit:
      content.add($field.floatVal)
    of nnkStrLit..nnkTripleStrLit, nnkCommentStmt, nnkIdent, nnkSym:
      content.add(field.strVal)
    else:
      discard

  if params.len > 0:
    result = " " & params

  result.add(">" & content)

proc tagEnd(tagName: string, closed: bool): string =
  if closed:
    result = "</" & tagName & ">"
  else:
    result = "/>"

template createTagTemplate(macroName: untyped,
                           tagName: string,
                           closed: bool = true
                          ): untyped =
  macro `macroName`(fields: untyped): untyped =
    result = newStrLitNode(
      "<" & tagName &
      processFields(fields) &
      tagEnd(tagName, closed)
    )

macro createTag*(name: untyped, closed: bool = true): untyped =
  expectKind(name, nnkIdent)
  result = getAst(createTagTemplate(name, name.strVal, closed))
