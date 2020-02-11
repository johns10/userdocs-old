defmodule Storage.Helpers do

  def assign_provisional_id(changeset, "") do
    changes = Map.fetch!(changeset, :changes)
    |> Map.put(:id, :rand.uniform(10000000) + 10000000)
    Map.put(changeset, :changes, changes)
  end
  def assign_provisional_id(changeset, _) do
    changeset
  end

  def update_status(changeset, status) do
    IO.puts("Updating Status")
    changes = Map.fetch!(changeset, :changes)
    |> Map.put(:storage_status, status)
    Map.put(changeset, :changes, changes)
  end

  def validate_assoc(changeset, type, allowed_assoc) do
    #IO.puts("Validating Association")
    changeset
    |> changeset_has_assoc?(type)
    |> assoc_exists?(type, allowed_assoc)
    |> update_changeset(type)
  end

  def changeset_has_assoc?(changeset, type) do
    case changeset.params[Atom.to_string(type) <> "_id"] do
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
    id = changeset.params[Atom.to_string(type) <> "_id"]
    case Enum.find(allowed_assoc, fn(o) -> o.id == id end) do
      _ ->
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
    type_id = Atom.to_string(type) <> "_id"
    id = changeset.changes[String.to_atom(type_id)]

    changes = Map.fetch!(changeset, :changes)
    |> Map.put(String.to_atom(type_id), id)
    Map.put(changeset, :changes, changes)
  end

end
