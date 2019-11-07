
defmodule GraphqlWeb.Schema do
  use Absinthe.Schema
  import_types(GraphqlWeb.Schema.Types)

  query do
    field :pages, list_of(:page) do
      arg(:ids, list_of(:id))
      resolve(&Graphql.Page.PageResolver.get/2)
    end

    field :procedure, type: :procedure do
      arg(:id, type: :id)
      resolve(&Graphql.Procedure.ProcedureResolver.get/2)
    end

    field :procedures, list_of(:procedure) do
      arg(:ids, list_of(:id))
      resolve(&Graphql.Procedure.ProcedureResolver.get/2)
    end
  end

  mutation do

    #################### Page Mutations ##################

    @desc "Create a page"
    field :create_page, type: :page do
      arg(:url, non_null(:string))
      arg(:id, non_null(:id))

      resolve &Graphql.Page.PageResolver.create/3
    end
    @desc "Update a page"
    field :update_page, type: :page do
      arg(:url, non_null(:string))
      arg(:id, non_null(:id))

      resolve &Graphql.Page.PageResolver.update/3
    end
    @desc "Delete a page"
    field :delete_page, type: :page do
      arg(:id, non_null(:id))

      resolve &Graphql.Page.PageResolver.delete/3
    end

    #################### Procedure Mutations ##################

    @desc "Create a procedure"
    field :create_procedure, type: :procedure do
      arg(:name, non_null(:string))
      arg(:id, non_null(:id))

      resolve &Graphql.Procedure.ProcedureResolver.create/3
    end

    @desc "Update a page"
    field :update_procedure, type: :procedure do
      arg(:name, non_null(:string))
      arg(:id, non_null(:id))

      resolve &Graphql.Procedure.ProcedureResolver.update/3
    end

    @desc "Delete a procedure"
    field :delete_procedure, type: :procedure do
      arg(:id, non_null(:id))

      resolve &Graphql.Procedure.ProcedureResolver.delete/3
    end
  end

end
