defmodule Graphql.Page.PageResolver do

  @graphql_type :page

  def get(args, _info) do
    Graphql.Helpers.get(args, @graphql_type)
  end

  def create(_parent, args, _info) do
    Graphql.Helpers.create(args, @graphql_type)
  end

  def update(_parent, args, _info) do
    Graphql.Helpers.create(args, @graphql_type)
  end

  def delete(_parent, args, _info) do
    Graphql.Helpers.delete(args, @graphql_type)
  end

end
