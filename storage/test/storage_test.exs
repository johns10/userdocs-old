defmodule StorageTest do
  use ExUnit.Case
  doctest Storage

  test "update annotation returns prepped changeset" do
    annotation = %{ "annotation_type" => "outline", "description" => "asdf", "label" => "asdf", "page" => "default", "selector" => "asdf", "strategy" => "id", "type" => "annotation" }
    pages = %{ default: %{ active: true, procedure: :default_procedure, type: :page, url: "www.google.com" }, default2: %{ active: false, procedure: :default_procedure_2, type: :page, url: "www.msn.com" } }
    annotation_types = %{ badge: %{ params: ['size', 'radius', 'label'], script: "var size = {size}; var label = {label}; var color = '{color}'; var wrapper = document.createElement('div'); var badge = document.createElement('span'); var textnode = document.createTextNode(label); element.appendChild(wrapper); badge.appendChild(textnode); wrapper.appendChild(badge); element.style.position = 'relative'; wrapper.style.display = ''; wrapper.style.justifyContent = 'center'; wrapper.style.alignItems = 'center'; wrapper.style.minHeight = ''; wrapper.style.position = 'absolute'; wrapper.style.top = (-1 * size).toString(10) + 'px'; wrapper.style.right = (-1 * size).toString(10) + 'px'; badge.style.display = 'inline-block'; badge.style.minWidth = '16px'; badge.style.padding = (0.5 * size).toString(10) + 'px ' + (0.5 * size).toString(10) + 'px'; badge.style.borderRadius = '50%'; badge.style.fontSize = '25px'; badge.style.textAlign = 'center'; badge.style.background = color; badge.style.color = 'white';" }, outline: %{ params: ['color', 'thickness'], script: "element.style.outline = '{color} solid {thickness}px'" } }
    expected_result = #Ecto.Changeset< action: nil, changes: %{ annotation_type: :outline, description: "asdf", label: "asdf", page: :default, selector: "asdf", strategy: "id", type: "annotation" }, errors: [], data: #Storage.AnnotationForm<>, valid?: true >
    result = %Storage.AnnotationForm{}
    |> Storage.AnnotationForm.changeset(
      annotation,
      %{ pages: pages, annotation_types: annotation_types } )
    assert result == expected_result
  end
end
