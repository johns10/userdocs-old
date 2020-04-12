defmodule LiveViewWeb.Types.Page do
  use Phoenix.LiveView

  def new_map(assigns) do

    %{
    }
  end

  def associations(assigns) do
    %{

    }
  end

  def expand_page(socket, id) do
    Helpers.expand(socket, id, :active_pages)
  end

  def toggle_new_form_mode(socket, id, mode) do
    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:ui, "page-menu", "form-modes", id], mode)
    assign(socket, assigns)
  end

  def annotations_steps(assigns, page) do
    { state, steps } = StateHandlers.get_related(assigns, :page_id, [page], :step)
    { state, annotations } = StateHandlers.get_related(assigns, :page_id, [page], :annotation)
    annotations = Enum.map(
      annotations,
      fn(annotation) ->
        { assigns, steps } = StateHandlers.get_related(
          assigns, :annotation_id, [annotation], :step)
        Map.put(
          annotation,
          :order,
          Enum.reduce(
            steps,
            999999999999999,
            fn(step, acc) ->
              min(step.order, acc)
            end
          )
        )
      end
    )
    steps = Enum.filter(steps, fn(step) -> step.annotation_id == nil end)
    Enum.sort(steps ++ annotations, &(&1.order <= &2.order))
  end


end
