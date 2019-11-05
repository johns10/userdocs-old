defmodule Graphql.Page.PageResolver do

  @graphql_type :page

  def get(args, %{context: %{ state: state }}) do
    Graphql.Helpers.get(state, args, @graphql_type)
  end

  def create(_parent, args, %{context: %{ state: state }}) do
    Graphql.Helpers.create(state, args, @graphql_type)
    |> IO.inspect()
  end

end
