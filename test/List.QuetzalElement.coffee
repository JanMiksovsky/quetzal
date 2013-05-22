test "List: create div elements for children", ->
  div = document.createElement "div"
  list = new List div
  div.items = [
    "One"
    "Two"
    "Three"
  ]
  equal div._wrappers.List.children.length, 3
  # TODO: See if we can simplify the result below a bit.
  renderEqual div, "<div class=\"QuetzalElement wrapper\"><div><div>One</div><div>Two</div><div>Three</div></div></div>"
