defmodule Subscription.Handler do

  def handle( type, :create = command, id, object, state ) do
    { state, data } = StateHandlers.create(state, type, id, object)
    state
  end
  def handle( type, :update = command, id, object, state ) do
    { state, data } = StateHandlers.create(state, type, id, object)
    state
  end
  def handle( type, :delete = command, id, object, state ) do
    { state, data } = StateHandlers.delete(state, type, id)
    state
  end

end
