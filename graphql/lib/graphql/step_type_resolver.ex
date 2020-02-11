defmodule Graphql.StepType.StepTypeResolver do

  @graphql_type :step_type

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

  def get(parent, args, _info) do
    IO.puts("In parent step")
    Graphql.Helpers.get(
      %{id: Graphql.Helpers.atoms_to_strings(parent.steps)},
        @graphql_type
      )
  end

  def args(parent, _args, _info) do
    { :ok, %{ id: "test" }}
  end

end
