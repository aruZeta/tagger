type
  Tag* = ref object
    ## A simple Tag object with a name, parameters and content if it's a closed
    ## tag (closed: `<p></p>`, not closed: `<img/>`)
    name*: string
    params*: string
    case closed*: bool
    of true:
      content*: string
    of false:
      discard

proc addParam*(tag: Tag, param: string, value: string) =
  ## Adds a parameter `param` with the value `value` to the tag `tag`.
  ## For simplicity, a Tag object's `params` is a string, so to add it a proper
  ## parameter it needs to be parsed.
  tag.params.add(" " & param & "=\"" & value & "\"")

proc newParam*(param: string, value: string): string =
  ## Returns a string holding the value of a parsed paramater you can add to a
  ## Tag object's `params`. Useful for making Tag one-liners.
  result = " " & param & "=\"" & value & "\""

proc newTag*(name: string, closed: bool = true): Tag =
  ## Returns a new Tag object, whose name is `name` and by default is closed
  Tag(name: name, closed: closed)

proc `$`*(tag: Tag): string =
  ## Returns the string representation of a Tag
  result = "<" & tag.name & tag.params
  if tag.closed:
    result.add(">" & tag.content & "</" & tag.name & ">")
  else:
    result.add("/>")
