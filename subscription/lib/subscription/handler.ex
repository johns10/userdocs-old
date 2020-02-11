defmodule Subscription.Handler do

  def handle( type, :create = command, object, state ) do
    { state, data } = StateHandlers.create(state, type, object)
    state
  end
  def handle( type, :update = command, object, state ) do
    { state, data } = StateHandlers.update(state, type, object)
    state
  end
  def handle( type, :delete = command, id, object, state ) do
    { state, data } = StateHandlers.delete(state, type, id)
    state
  end

end
