defmodule PubSub.Annotation do
  @pubsub_name :annotation
  @pubsub_topic "annotation_updates"

  def create(id, object) when is_atom(id) and is_map(object) do
    Phoenix.PubSub.broadcast(@pubsub_name, @pubsub_topic, {:create, id, object})
  end
end
