defmodule Script.Script do
  @doc """
    Takes a script, a list of types, a list of named components with prototypes
    and arguments, generates script components from each entry and concatenates
    them.
    script: the script to concatenate additional entries to.  Initially should
    be empty
    list of script maps, each with a type and a list of args
    types: a list of script types with a type, prototype, and list of valid
    parameters

    Returns the interpolated strings for each script, concatenated
    """
    @doc since: "1.9.2"
    #TODO: Re-implement as a prototype
  def generate_script(script, [ %{ type: type, args: args} | list ], types) do
    generate_prototype(type, types[type].prototype, args)
    |> interpolate_prototype()
    |> generate_script(list, types)
    |> prepend(script)
  end
  def generate_script(script, [], _) do
    script
  end

  @doc """
    Generates a named script component, with some arguments.  Mostly for type checking.
    prototype: an eex string with named attributes
    args: a list of named arguments

    Returns the interpolated string
    """
    @doc since: "1.9.2"
    #TODO: Re-implement as a prototype
  def generate_prototype(:select_xpath, prototype, args = [ selector: _selector ]) do
    { prototype, args }
  end
  def generate_prototype(:outline, prototype, args = [ color: _color, thickness: _thickness ]) do
    { prototype, args }
  end
  def generate_prototype(:badge, prototype, args = [ radius: _radius, label: _label, color: _color ]) do
    { prototype, args }
  end
  def generate_prototype(_, prototype, args) do
    { prototype, args }
  end
  @doc """
    Interpolates an eex string with named attributes.
    prototype: an eex string with named attributes
    args: a list of named arguments

    Returns the interpolated string
    """
  @doc since: "1.9.2"
  def interpolate_prototype({ prototype, args }) do
    EEx.eval_string(prototype, args)
  end

  @doc """
    Implements reverse concatenation
    tail: tail of the string to return
    head: head of the string to return

    Returns the prepended head
    """
    @doc since: "1.9.2"
  def prepend(tail, []) do
    tail
  end
  def prepend(tail, head) do
    head <> tail
  end
end

