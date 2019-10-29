defmodule ScriptTest do
  use ExUnit.Case
  doctest Script

  test "generates a whole script" do
    types = %{
      select_xpath: %{
        prototype: "Selector: <%= selector %>\n",
        args: [ 'selector' ]
      },
      outline: %{
        prototype: "Color: <%= color %>, Thickness: <%= thickness %>\n",
        args: [ 'color', 'thickness' ]
      },
      badge: %{
        prototype: "Radius: <%= radius %>, Label: <%= label %>, Color: <%= color %>\n",
        args: [ 'radius', 'label', 'red' ]
      }
    }
    list = [
      %{
        type: :select_xpath,
        args: [ selector: ~s|/html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Password']|]
      },
      %{
        type: :outline,
        args: [ color: 'red', thickness: '10' ]
      },
      %{
        type: :badge,
        args: [ radius: '50', label: '1', color: 'red' ]
      }
    ]
    result = Script.Script.generate_script('', list, types)
    assert(result == "Selector: /html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Password']\nColor: red, Thickness: 10\nRadius: 50, Label: 1, Color: red\n")
  end

  test "interpolate string returns matching string" do
    prototype = "The <%= adj %> <%= adj2 %> <%= noun %>"
    args = [ adj: "quick", adj2: "brown", noun: "fox" ]
    result = Script.Script.interpolate_prototype({ prototype, args })
    assert(result == "The quick brown fox")
  end

  test "Generates a badge script" do
    prototype = "Radius: <%= radius %>, Label: <%= label %>, Color: <%= color %>"
    args = [ radius: '10', label: 'label', color: 'red']
    result = Script.Script.generate_prototype(:badge, prototype, args)
    assert(result == { prototype, args })
  end

  test "Generates an outline script" do
    prototype = "Color: <%= color %>, Thickness: <%= thickness %>"
    args = [ color: 'red', thickness: '10' ]
    result = Script.Script.generate_prototype(:outline, prototype, args)
    assert(result == { prototype, args })
  end

  test "Generates an xpath selector script" do
    prototype = "Selector: <%= selector %>"
    args = [ selector: 'select' ]
    result = Script.Script.generate_prototype(:select_xpath, prototype, args)
    assert(result == { prototype, args })
  end
end
