defmodule StateHandlers do

  defdelegate get(state, type, ids \\ []), to: StateHandlers.Handle

  defdelegate get_related(state, from_type, from_ids, to_type), to: StateHandlers.Handle

  defdelegate create(state, type, id, object), to: StateHandlers.Handle

  defdelegate update(state, type, id, object), to: StateHandlers.Handle

  defdelegate delete(state, type, id), to: StateHandlers.Handle

end
