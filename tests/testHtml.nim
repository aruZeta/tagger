import std/unittest
import tagger/html

test "Minimal tag":
  let tag = p:
    id = "paragraph1"

  check tag == """<p id="paragraph1"></p>"""

test "Complex tag":
  let tag = hdiv:
    id = "parent"
    p:
      id = "child"

  check tag == """<div id="parent"><p id="child"></p></div>"""
