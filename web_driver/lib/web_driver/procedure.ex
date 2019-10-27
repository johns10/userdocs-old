defmodule WebDriver.Procedure do

  @default_retries 5


  def execute_procedure([ step | procedure]) do
    { type, args } = Map.pop(step, :type)
    IO.puts("Executing Procedure #{type}")
    execute_procedure_step(type, args)
    execute_procedure(procedure)
  end

  def execute_procedure([]) do

  end


  def execute_procedure_step(:navigate, %{ url: url }) do
    IO.puts("Executing Navigation Step #{url}")
    WebDriver.Driver.h_navigate_to(url)
  end

  def execute_procedure_step(:wait, %{ strategy: strategy, selector: selector }) do
    IO.puts(selector)
    WebDriver.Driver.wait_until_available(strategy, selector, @default_retries)
  end

  def execute_procedure_step(:click, %{ strategy: strategy, selector: selector }) do
    IO.puts("Executing Click Step")
    WebDriver.Driver.h_find_element(strategy, selector, @default_retries)
    |> WebDriver.Driver.h_click()
  end

  def execute_procedure_step(:fill_field, %{ strategy: strategy, selector: selector, text: text}) do
    IO.puts("Executing fill field step")
    WebDriver.Driver.h_find_element(strategy, selector, @default_retries)
    |> WebDriver.Driver.h_fill_field(text)
  end

  def execute_procedure_step(:wait_click) do

  end

end
