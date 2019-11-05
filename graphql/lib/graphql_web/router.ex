defmodule GraphqlWeb.Router do
  use GraphqlWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug GraphqlWeb.Context
  end

  scope "/api" do
    pipe_through(:api)

    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      [
        schema: GraphqlWeb.Schema,
        interface: :playground
      ]

    forward "/",
      Absinthe.Plug,
      GraphqlWeb.Schema
  end
end
