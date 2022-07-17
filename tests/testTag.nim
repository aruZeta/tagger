import unittest
import tagger/tag

test "Minimal tag":
  let tag = newTag("p", true)
  tag.addParam "id", "paragraph1"

  check $tag == """<p id="paragraph1"></p>"""

test "Complex tag":
  let myDiv = newTag("div", true)
  myDiv.addParam "id", "parent"

  let myP = newTag("p", true)
  myP.addParam "id", "child"

  myDiv.content.add $myP

  check $myDiv == """<div id="parent"><p id="child"></p></div>"""

test "Minimal tag one-liner":
  check $Tag(
    name: "p",
    params: newParam("id", "paragraph1"),
    closed: true
  ) == """<p id="paragraph1"></p>"""

test "Complex tag one-liner":
  check $Tag(
    name: "div",
    params: newParam("id", "parent"),
    closed: true,
    content: $Tag(
      name: "p",
      params: newParam("id", "child"),
      closed: true
    )
  ) == """<div id="parent"><p id="child"></p></div>"""
