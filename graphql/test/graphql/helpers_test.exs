defmodule Graphql.HelpersTest do
  use ExUnit.Case
  doctest State

  test "state_to_graphql returns translated object" do
    key = :default_procedure
    object = %{
      type: :procedure,
      attributes: %{
        name: "Procedure Name"
      },
      relationships: %{
        step: [:default],
        page: [:default]
      }
    }
    result = Graphql.Helpers.state_to_graphql({ key, object })
    assert(result == %{id: :default_procedure, name: "Procedure Name"})
  end

  test "graphql_to_state returns state object" do
    object = %{id: "default", url: "www.google.com"}
    type = :page
    result = Graphql.Helpers.graphql_to_state(object, type)
    assert(result == %{default: %{attributes: %{url: "www.google.com"}}, type: :page})
  end

end
