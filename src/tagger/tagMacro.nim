import std/macros
from std/strutils import join

type
  TagMacro* = ref object
    name*: string
    params*: seq[NimNode]
    case closed*: bool
    of true:
      contents*: seq[NimNode]
    of false:
      discard

proc getNodeArray(tag: TagMacro): NimNode =
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
  let
    actualMacroName = newIdentNode(macroName.strVal)
    name = if tagName.strVal.len == 0:
             macroName.strVal
           else:
             tagName.strVal
  result = quote do:
    macro `actualMacroName`(fields: untyped): untyped =
      let tag = TagMacro(
        name: `name`,
        closed: `closed`
      )
      fillFields tag, fields
      result = newCall(
        newIdentNode("join"),
        getNodeArray tag
      )

export join
