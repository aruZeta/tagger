import std/macros
from std/strutils import join

type
  TagMacro = ref object
    ## A tag object used by a tag macro to hold the name of the tag, params and
    ## contents if it's a closed tag (closed: `<p></p>`, not closed: `<img/>`)
    name*: string
    params*: seq[NimNode]
    case closed*: bool
    of true:
      contents*: seq[NimNode]
    of false:
      discard

proc getNodeArray(tag: TagMacro): NimNode =
  ## Returns the AST of an array containing all the components which
  ## concatenated form a string representing the tag `tag`
  result = nnkBracket.newTree()
  var lastNode: string = "<" & tag.name

  template maybeAdd(item: string) =
    if lastNode.len > 0:
      lastNode.add item
    else:
      lastNode = item

  template maybeAddLoop(items: seq[NimNode]) =
    for item in items:
      case item.kind
      of nnkCharLit..nnkUInt64Lit:   maybeAdd $item.intVal
      of nnkFloatLit..nnkFloat64Lit: maybeAdd $item.floatVal
      of nnkStrLit..nnkTripleStrLit: maybeAdd item.strVal
      else:
        result.add newLit(lastNode)
        result.add item
        lastNode.setLen 0

  maybeAddLoop tag.params

  if tag.closed:
    maybeAdd ">"
    maybeAddLoop tag.contents
    maybeAdd "</" & tag.name & ">"
  else:
    maybeAdd "/>"

  if lastNode.len > 0:
    result.add newLit(lastNode)

proc fillFields(tag: TagMacro, fields: NimNode) =
  ## Loops through the fields of a tag macro, if the field is a paramater
  ## it is added to the tag's paramater list, if not to the tag's content list
  for field in fields:
    case field.kind
    of nnkAsgn:
      tag.params.add newLit(" " & field[0].strVal & "=\"")
      tag.params.add field[1]
      tag.params.add newLit("\"")
    else:
      tag.contents.add field

macro createTag*(macroName: untyped,
                 tagName: string = "",
                 closed: bool = true
                ): untyped =
  ## Creates a new macro named `macroName` which is used to generate a tag
  ## named `tagName` (by default is the same as the `macroName` unless it
  ## is specified otherwise). The tag can be closed or not (by default it's
  ## closed). A closed tag looks like: `<p></p>`, and not closed: `<img/>`
  let
    tagName =
      if tagName.strVal.len == 0:
        macroName.strVal
      else:
        tagName.strVal
    macroName = newIdentNode(macroName.strVal)
  result = quote do:
    macro `macroName`(fields: untyped): untyped =
      let tag = TagMacro(
        name: `tagName`,
        closed: `closed`
      )
      fillFields tag, fields
      result = newCall(
        newIdentNode("join"),
        getNodeArray tag
      )

export join
