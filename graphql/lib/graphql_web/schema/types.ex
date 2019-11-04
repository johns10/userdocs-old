defmodule GraphqlWeb.Schema.Types do

  use Absinthe.Schema.Notation

  object :page, name: "Page" do
    field(:id, :id)
    field(:url, :string)
    field(:procedures, list_of(:procedure))
  end

  object :procedure do
    field(:id, :id)
    field(:name, :string)
  end

end
