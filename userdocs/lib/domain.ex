defmodule Userdocs.Domain do

  def expand(assigns, id, list) do
    active_objects =
      assigns[list]
      |> Enum.member?(id)
      |> toggle_active_element(assigns, id, list)

    Map.put(assigns, list, active_objects)
  end

  def toggle_active_element(false, assigns, id, list) do
    [id | assigns[list]]
  end
  def toggle_active_element(true, assigns, id, list) do
    Enum.filter(
      assigns[list],
      fn o ->
        o != id
      end
    )
  end

end
