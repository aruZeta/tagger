import unittest
import tagger

test "Minimal tag":
  createTag p

  let tag = p:
    id = "test"
    "Test text"

  check tag == "<p id=\"test\">Test text</p>"

test "Minimal tag with multiple content fields":
  createTag p

  let tag = p:
    id = "test"
    "Test text, value: "
    1

  check tag == "<p id=\"test\">Test text, value: 1</p>"

test "Minimal tag with multiple params":
  createTag p

  let tag = p:
    id = "test"
    class = "test"
    "Test text"

  check tag == "<p id=\"test\" class=\"test\">Test text</p>"
