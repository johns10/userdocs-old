defmodule LiveViewWeb.StepArgs do
  use Phoenix.LiveView
  use Phoenix.HTML

  def render(%{ step_type_id: 1 }, f, assigns) do
    ~L"""
    <label for="step-form-url-input">URL</label>
    <%= text_input f, :url %>
    """
  end

  def render(%{ step_type_id: 2 }, f, assigns) do
    ~L"""
    <label for="step-form-strategy-input">Strategy</label>
    <%= text_input f, :strategy %>
    <label for="step-form-selector-input">Selector</label>
    <%= text_input f, :selector %>
    """
  end

  def mount(_session, socket) do
    { :ok, socket }
  end
end
