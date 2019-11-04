defmodule Graphql.Page.PageResolver do
  alias Graphql.Accounts                    #import lib/graphql/accounts/accounts.ex as Accounts

  def all(_args, _info) do
    {:ok, Accounts.list_users()}
  end

  def find(%{id: id}, _info) do
    { :ok }
  end
end
