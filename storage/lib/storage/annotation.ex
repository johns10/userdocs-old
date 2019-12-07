defmodule Storage.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "annotation" do
    field :strategy,    :string
    field :selector,    :string
    field :label,       :string
    field :description, :string
    field :type,        :string

    has_one     :annotation_type, Storage.AnnotationType
    belongs_to  :page,            Storage.Page

  end

  def changeset(annotation, params \\ %{}) do
    IO.puts("applying Changeset")
    #IO.inspect(params)
    annotation
    |> cast(params, [:strategy, :selector, :label, :description, :type])
    |> IO.inspect()
    #|> cast_assoc(:annotation_type, required: false)
    |> cast_assoc(:page, required: false)
    |> validate_required([:strategy, :selector, :type, :page, :annotation_type])
  end

end

defmodule Storage.AnnotationForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    @primary_key false
    field :title,           :string
    field :strategy,        :string
    field :selector,        :string
    field :label,           :string
    field :description,     :string
    field :type,            :string
    field :annotation_type, :string
    field :page,            :string
  end

  def changeset(annotation, params \\ %{}, args \\ %{}) do
    #IO.puts("applying Changeset")
    annotation
    |> cast(params, [:strategy, :selector, :label, :description, :type, :title, :id])
    |> validate_assoc(:page, args.pages)
    |> validate_assoc(:annotation_type, args.annotation_types)
    |> validate_required([:strategy, :selector, :type, :page, :annotation_type])

    #IO.inspect(changeset.data)
  end

  def validate_assoc(changeset, type, allowed_assoc) do
    #IO.puts("Validating Association")
    changeset
    |> changeset_has_assoc?(type)
    |> assoc_exists?(type, allowed_assoc)
    |> update_changeset(type)
  end


  def changeset_has_assoc?(changeset, type) do
    IO.inspect(changeset.params[Atom.to_string(type)])
    case changeset.params[Atom.to_string(type)] do
      { :error } ->
        { :ok, errors } = Map.fetch(changeset, :errors)
        errors = List.insert_at(errors, 0, { type, "#{type} association field is invalid" })
        changeset = Map.put(changeset, :errors, errors)
        { :nok, changeset }
      nil  ->
        { :ok, errors } = Map.fetch(changeset, :errors)
        errors = List.insert_at(errors, 0, { type, "#{type} association field is invalid" })
        changeset = Map.put(changeset, :errors, errors)
        { :nok, changeset }
      _ ->
        { :ok, changeset }
    end
  end

  def assoc_exists?({ :nok, changeset}, _, _) do
    { :nok, changeset }
  end
  def assoc_exists?({ :ok, changeset }, type, allowed_assoc) do
    id = changeset.params[Atom.to_string(type)]
    case Map.fetch(allowed_assoc, String.to_atom(id)) do
      { :ok, _ } ->
        { :ok, changeset }
      ArgumentError ->
        { :ok, errors } = Map.fetch(changeset, :errors)
        errors = List.insert_at(errors, 0, { type, "Associated record doesn't exist" })
        changeset = Map.put(changeset, :errors, errors)
        { :nok, changeset }
      nil ->
        { :ok, errors } = Map.fetch(changeset, :errors)
        errors = List.insert_at(errors, 0, { type, "Associated record doesn't exist" })
        changeset = Map.put(changeset, :errors, errors)
        { :nok, changeset }
    end
  end

  def update_changeset({ :nok, changeset }, _) do
    changeset
  end
  def update_changeset({ :ok, changeset }, type) do
    id = changeset.params[Atom.to_string(type)]

    changes = Map.fetch!(changeset, :changes)
    |> Map.put(type, String.to_atom(id))
    Map.put(changeset, :changes, changes)
  end

end
