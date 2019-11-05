
defmodule GraphqlWeb.Schema do
  use Absinthe.Schema
  import_types(GraphqlWeb.Schema.Types)

  query do
    field :new, type: :state do
      resolve(&Graphql.State.StateResolver.new/2)
    end

    field :pages, list_of(:page) do
      arg(:ids, list_of(:id))
      resolve(&Graphql.Page.PageResolver.get/2)
    end
  end

  mutation do

    @desc "Create a page"
    field :create_page, type: :page do
      arg(:url, non_null(:string))
      arg(:id, non_null(:id))

      resolve &Graphql.Page.PageResolver.create/3
    end

  end

end
