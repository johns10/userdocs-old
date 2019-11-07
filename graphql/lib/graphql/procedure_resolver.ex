defmodule Graphql.Procedure.ProcedureResolver do

  @graphql_type :procedure

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

  ################ Relationships ##############

  def get(parent = %{ type: :page }, args, _info) do
    Graphql.Helpers.get(%{ id: to_string(parent.procedure) }, @graphql_type)
  end

end
