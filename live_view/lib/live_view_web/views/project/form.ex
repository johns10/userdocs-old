defmodule LiveViewWeb.Project.Form do
  require Logger

  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.ErrorHelpers
  alias LiveViewWeb.InputHelpers
  alias LiveViewWeb.Helpers

  def render(assigns, project_changeset) do
    Logger.debug("Rendering Project Form")
    f = form_for( project_changeset, "#", [ ])
    content_tag(:div, [
      class: "modal fade show",
      id: "contentModal",
      tabindex: "-1",
      role: "dialog",
      aria_labelledby: "contentModalLabel",
      aria_hidden: "true",
      style: "display: block; padding-right: 17px"
    ]) do
      content_tag(:div, [ class: "modal-dialog", role: "document" ]) do
        content_tag(:div, [ class: "modal-content" ]) do
          [
            content_tag(:div, [ class: "modal-header" ]) do
              [
                content_tag(:h5, [
                  class: "modal-title",
                  id: "contentModalLabel"
                ]) do
                  "Project"
                end,
                content_tag(:button, [
                  type: "button",
                  class: "close",
                  data_dismiss: "modal",
                  aria_label: "Close",
                  phx_click: "project::close_modal",
                ]) do
                  content_tag(:i, [ class: "fa fa-times" ]) do
                    ""
                  end
                end
              ]
            end,
            content_tag(:form, [
              phx_submit: :"project::save",
              phx_change: :"project::validate"
            ]) do
              [
                content_tag(:div, [ class: "modal-body" ]) do
                  [
                    hidden_input(f, :team_id, value: f.params["team_id"]),
                    hidden_input(f, :id, value: f.params["id"]),
                    hidden_input(f, :storage_status, value: f.params["storage_status"]),
                    hidden_input(f, :record_status, value: f.params["record_status"]),
                    "Record Status",
                    f.params["record_status"],
                    InputHelpers.input(f, :name, [
                      using: :text_input,
                      value: f.params["name"],
                      id: "project-name-text-input",
                      placeholder: "Google"
                    ]),
                    InputHelpers.input(f, :base_url, [
                      using: :text_input,
                      value: f.params["base_url"],
                      id: "project-base-url-text-input",
                      placeholder: "www.google.com"
                    ]),
                    InputHelpers.input(f, :project_type, [
                      using: :text_input,
                      value: f.params["project_type"],
                      id: "project-project-type-text-input",
                      placeholder: "Web"
                    ])
                  ]
                end,
                content_tag(:div, [ class: "modal-footer" ]) do
                  [
                    InputHelpers.button_save(f),
                    InputHelpers.button_remove("project", project_changeset.params["id"]),
                    InputHelpers.button_cancel("project", project_changeset.params["id"])
                  ]
                end
              ]
            end
          ]
        end
      end
    end
  end



  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
