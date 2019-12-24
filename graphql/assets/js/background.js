<%= for { id, project } <- @project do %>
              <%= project.title %>
              <%= for step <- Helpers.children(:project, id, :step, @step) do %>
                <%= LiveViewWeb.StepView.render(step, assigns) %>
              <% end %>
              <%= for { id, page } <- Helpers.children(:project, id, :page, @page) do %>
                <div class="uk-flex-inline">
                  <a
                    href="#"
                    phx-click="active_element"
                    phx-value-id="<%= id %>"
                    phx-value-type="<%= page.type %>"
                    class="uk-align-left"
                  >
                    <h3>
                      <%= page.url %>
                    </h3>
                  </a>
                  <%= if Helpers.has_children(:page, id, @job) do %>
                  <button
                    href="#"
                    phx-click="annotate_page"
                    phx-value-id="<%= id %>"
                    phx-value-type="<%= page.type %>"
                    class="uk-button-small uk-align-right"
                  >
                    Annotate
                  </button>
                  <%= else %>
                    <button
                      href="#"
                      phx-click="annotate_page"
                      phx-value-id="<%= id %>"
                      phx-value-type="<%= page.type %>"
                      class="uk-button-small uk-align-right"
                    >
                      Annotate
                    </button>
                  <%= end %>
                  <%= for { id, job } <- Helpers.children(:page, id, :job, @job) do %>
                    <%= job.status %>
                  <% end %>
                </div>
                <%= if page.active == true do %>
                  <div>
                    <ul>
                      <%= for step <- Helpers.children(:page, id, :step, @step) do %>
                        <%= LiveViewWeb.StepView.render(step, assigns) %>
                      <% end %>
                    </ul>
                  </div>
                  <hr class="uk-divider-icon">
                  <div>
                    <ul>
                      <%= for annotation <- Helpers.children(:page, id, :annotation, @annotation) do %>
                        <%= LiveViewWeb.Annotation.render(:view, annotation, assigns) %>
                      <% end %>
                    </ul>
                  </div>
                  <div>
                    <%= if @new_annotation == false do %>
                      <button
                        class="uk-button uk-button-primary uk-width-1-1"
                        uk-icon="plus"
                        phx-click="hello"
                        >
                      </button>
                    <% else %>
                      <%= LiveViewWeb.Annotation.render(
                        :form,
                        page.type,
                        id,
                        { "test", %Storage.AnnotationForm{ } },
                        assigns
                      ) %>
                    <% end %>
                  </div>
                <% end %>
              <% end %>
            <% end %>