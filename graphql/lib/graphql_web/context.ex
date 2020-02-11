defmodule GraphqlWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    '''
    Depreciated in favor of singleton state.  Could be reused to implement users.
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      _ ->
        conn
    end
    '''
    conn
  end
'''
Depreciated in favor of singleton state.
  defp build_context(conn) do
    state = State.new()
    {:ok, %{state: state}}
  end
  '''
end
