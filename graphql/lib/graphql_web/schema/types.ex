defmodule GraphqlWeb.Schema.Types do

  use Absinthe.Schema.Notation

  object :procedure, name: "Procedure" do
    field(:id, :id)
    field(:name, :string)
    field(:steps, list_of(:step)) do
      resolve &Graphql.Step.StepResolver.get/3
    end
  end

  object :state do
    field(:pid, :string)
  end

  object :page, name: "Page" do
    field(:id, :id)
    field(:type, :string)
    field(:url, :string)
    field(:procedure, type: :procedure) do
      arg(:id)
      resolve(&Graphql.Procedure.ProcedureResolver.get/3)
    end
  end

  object :step, name: "Step" do
    field(:id, :id)
    field(:type, :string)
    field(:strategy, :string)
    field(:args, list_of(:arg)) do
      resolve(&Graphql.Step.StepResolver.args/3)
    end
    field(:step_type, type: :step_type) do
      arg(:id)
      resolve(&Graphql.StepType.StepTypeResolver.args/3)
    end
  end

  object :step_type, name: "JavaScript Step Type" do
    field(:id, :id)
    field(:type, :id)
    field(:args, list_of(:string))
  end

  object :arg, name: "Key-Value Argument Pair" do
    field(:key, :id)
    field(:type, :string)
    field(:value, :string)
  end

end
