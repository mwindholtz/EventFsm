defmodule EventFsm.Evt do
  @moduledoc """
    a Domain Event
  """
  alias EventFsm.Evt
  alias EventFsm.Rules

  @enforce_keys [:name]

  defstruct name: "unnamed",
            content: :no_evt_content,
            source: ""

  # Helper functions absed on where the Event originates

  def coin_acceptor(name, content \\ :no_evt_content) do
    new_from(name, content, "CoinAcceptor")
  end

  # Helper functions absed on where the Event originates
  def turnstyle(name, content \\ :no_evt_content) do
    new_from(name, content, "TurnStyle")
  end

  # ---------------------------------------------------------- 

  # header to set default validator  
  def new(name, content, validator \\ Rules)

  # function  heads
  def new(name, content_tuple, validator) when is_tuple(content_tuple) do
    validator.validate!(name)
    %Evt{name: normalize!(name), content: content_tuple}
  end

  def new(name, :no_evt_content, _validator) do
    %Evt{name: normalize!(name)}
  end

  def new(name, content, _validator) do
    %Evt{name: normalize!(name), content: content}
  end

  def new(name) do
    Rules.validate!(name)
    %Evt{name: normalize!(name), content: :no_evt_content}
  end

  def new_from(name, content, source) do
    %{Evt.new(name, content) | source: source}
  end

  def normalize!(string_or_atom) do
    string_or_atom
    |> to_string
    |> Macro.underscore()
    |> String.to_existing_atom()
  end

  defimpl EventFsm.Journalable, for: EventFsm.Evt do
    def to_entry(evt), do: %{name: evt.name, content: evt.content}
  end
end
