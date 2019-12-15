defmodule WebDriver.Procedure do

  @default_retries 5

  def execute_procedure(procedure) do
    execute_procedure( :ok, procedure )
  end
  def execute_procedure( :ok, [ step | procedure ] ) do
    IO.puts("executing procedure")
    IO.inspect(step)
    step
    |> execute_procedure_step()
    |> execute_procedure(procedure)
  end
  def execute_procedure( :ok, [] ) do
  end

  def execute_procedure_step({ :navigate, %{ url: url } }) do
    IO.puts("Executing Navigation Step #{url}")
    WebDriver.Driver.h_navigate_to(url)
    :ok
  end
  def execute_procedure_step({ :wait, %{ strategy: strategy, selector: selector } }) do
    IO.puts(selector)
    wait_until_available(strategy, selector, 10)
    :ok
  end
  def execute_procedure_step({ :click, %{ strategy: strategy, selector: selector } }) do
    IO.puts("Executing Click Step")
    WebDriver.Driver.h_find_element(strategy, selector, @default_retries)
    |> WebDriver.Driver.h_click()
    :ok
  end
  def execute_procedure_step({ :fill_field, %{ strategy: strategy, selector: selector, text: text } }) do
    IO.puts("Executing fill field step")
    WebDriver.Driver.h_find_element(strategy, selector, @default_retries)
    |> WebDriver.Driver.h_fill_field(text)
    :ok
  end
  def execute_procedure_step({ :javascript, args }) do
    IO.puts("Executing Javascript Step")
    { script_type, args } = Map.pop(args, :script_type)
    WebDriver.Driver.h_execute_script(
      prototype(script_type),
      ordered_arguments(args, script_type)
    )
    :ok
  end

  def prototype(script_type) do
    State.get(:script, script_type)
    |> Map.values()
    |> Enum.at(0)
    |> Map.get(:prototype)
  end

  def ordered_arguments(args, script_type) do
    Enum.reduce(
      Enum.reverse(script_arguments(script_type)),
      [],
      fn(arg, ordered_args) -> [ args[arg] | ordered_args ] end
      )
  end

  def script_arguments(script_type) do
    State.get(:script, script_type)
    |> Map.values()
    |> Enum.at(0)
    |> Map.get(:args)
  end

  def wait_until_available(strategy, selector, timeout) do
    { false, WebDriver.Driver.h_find_element(strategy, selector, 5) }
    |> wait_until_available(timeout)
  end
  def wait_until_available(request = { false, _element }, attempts_left ) when attempts_left > 0 do
  request
    |> WebDriver.Driver.h_element_displayed?()
    |> wait()
    |> wait_until_available(attempts_left - 1)
  end
  def wait_until_available({ true, element }, _ ) do
    { :ok, element }
  end
  def wait_until_available({ false, element }, 0 ) do
    { :nok, element }
  end

  def wait(request = { false, _element }) do
    :timer.sleep(1000)
    request
  end
  def wait(request = { true, _element }) do
    request
  end

end
