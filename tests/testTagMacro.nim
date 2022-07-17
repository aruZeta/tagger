import std/unittest
import tagger/tagMacro

test "Minimal tag":
  createTag p

  let tag = p:
    id = "paragraph1"

  check tag == """<p id="paragraph1"></p>"""

test "Complex tag":
  createTag hdiv, "div"
  createTag p

  let myDiv = hdiv:
    id = "parent"
    p:
      id = "child"

  check myDiv == """<div id="parent"><p id="child"></p></div>"""

test "Minimal tag with vars and proc calls":
  createTag "p"

  let
    id = "someID"
    lorem = "Ipsam minus sunt saepe."

  let tag = p:
    id = id
    "Some text. "
    lorem

  check tag == """<p id="someID">Some text. Ipsam minus sunt saepe.</p>"""

test "Complex tag with vars and proc calls":
  createTag hdiv, "div"
  createTag "p"

  let
    idParent = "parent"
    loremParent = "Ipsam minus sunt saepe."
    idChild = "child"
    loremChild = "Ipsum in laudantium dolorum quia."

  let tag = hdiv:
    id = idParent
    loremParent
    p:
      id = idChild
      loremChild

  check tag == """<div id="parent">Ipsam minus sunt saepe.<p id="child">Ipsum in laudantium dolorum quia.</p></div>"""
