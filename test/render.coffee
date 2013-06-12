test "Render: empty element", ->
  div = document.createElement "div"
  renderEqual div, ""

test "Render: element with text content", ->
  span = document.createElement "span"
  span.textContent = "Hello"
  renderEqual span, "Hello"

test "Render: element with attributes", ->
  div = document.createElement "div"
  span = document.createElement "span"
  span.setAttribute "foo", "one"
  span.setAttribute "bar", "two"
  div.appendChild span
  renderEqual div, "<span foo=\"one\" bar=\"two\"></span>"

test "Render: element with child elements", ->
  div = document.createElement "div"
  div.innerHTML = "<span>Hello,</span> <span>world.</span>"
  renderEqual div, "<span>Hello,</span> <span>world.</span>"

test "Render: element with shadow", ->
  div = document.createElement "div"
  div.innerHTML = "This shouldn't be rendered"  
  root = div.webkitCreateShadowRoot()
  root.innerHTML = "<div>Shadow</div>"
  renderEqual div, "<div>Shadow</div>"

test "Render: element with shadow with content", ->
  div = document.createElement "div"
  div.innerHTML = "OK"  
  root = div.webkitCreateShadowRoot()
  root.innerHTML = "<button><content></content></button>"
  renderEqual div, "<button>OK</button>"

test "Render: element with two shadows", ->
  div = document.createElement "div"
  div.innerHTML = "Alice"
  root1 = div.webkitCreateShadowRoot()
  root1.innerHTML = "<i><content></content></i>"
  root2 = div.webkitCreateShadowRoot()
  root2.innerHTML = "Hello, <shadow></shadow>."
  renderEqual div, "Hello, <i>Alice</i>."
