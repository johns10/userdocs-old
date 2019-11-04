
defmodule GraphqlWeb.Schema do
  use Absinthe.Schema
  import_types(GraphqlWeb.Schema.Types)

  query do
    field :pages, list_of(:page) do
      resolve(&Graphql.Page.PageResolver.all/2)
    end

    field :page, type: :page do
      arg(:id, non_null(:id))
      resolve(&Graphql.Page.PageResolver.find/2)
    end

    field :procedures, list_of(:procedure) do
      resolve(&Graphql.Procedure.ProcedureResolver.all/2)
    end

    field :procedure, :procedure do
      arg(:email, non_null(:string))
      resolve(&Graphql.Procedure.ProcedureResolver.find/2)
    end
  end
end
