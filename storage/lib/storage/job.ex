defmodule Storage.Job do
  use Ecto.Schema

  schema "job" do
    field :job_type, :string

    belongs_to :page,    Storage.Page
    belongs_to :project, Storage.Project
  end
end
