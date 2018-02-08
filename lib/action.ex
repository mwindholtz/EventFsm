defmodule EventFsm.Action do
  @moduledoc """
    The result of a state transition.
    Created by the Rules.transition_rules(), 
    Consumed by Resolver
  """

  defstruct name: :unnamed,
            content: :none,
            target: ""

  alias EventFsm.Action

  def new(name \\ :unnamed), do: %Action{name: name}

  # --- targets 

  def indicator(name, content \\ nil),
    do: %Action{name: name, target: "Indicator", content: content}

  def turnstyle(name \\ :unnamed), do: %Action{name: name, target: "Turnstyle"}
  def coin_acceptor(name \\ :unnamed), do: %Action{name: name, target: "CoinAcceptor"}

  # --- standard actions

  def store(tuple) when is_tuple(tuple),
    do: %Action{name: :store, content: tuple, target: "EventFsm"}

  def unlock, do: [turnstyle(:unlock), indicator(:green)]
  def lock, do: [turnstyle(:lock), indicator(:red)]
end
