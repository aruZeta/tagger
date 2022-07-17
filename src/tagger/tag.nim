type
  Tag* = ref object
    name: string
    params: string
    case closed: bool
    of true:
      content*: string
    of false:
      discard

proc addParam*(tag: Tag, param: string, value: string) =
  tag.params.add(" " & param & "=\"" & value & "\"")

proc newTag*(name: string, closed: bool): Tag =
  Tag(name: name, closed: closed)

proc `$`*(tag: Tag): string =
  result = "<" & tag.name & tag.params

  if tag.closed:
    result.add(">" & tag.content & "</" & tag.name & ">")
  else:
    result.add("/>")
