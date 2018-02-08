defmodule EventFsm.Rules do
  @moduledoc """
    Finite State Machine Workflow Rules
  """

  @no_change {:no_change, []}
  @unimplemented {:no_change, []}

  require Logger
  alias EventFsm.Action

  def states do
    [:locked, :unlocked]
  end

  def transition_rules() do
    %{
      {:locked, :coin_deposited} => {:unlocked, [Action.indicator(:green_light), Action.turnstyle(:unlock)]},
      {:unlocked, :turned_once} => {:locked,  [ Action.indicator(:red_light), 
                                                Action.turnstyle(:lock), 
                                                Action.coin_acceptor(:clear)]},
      {:any, :any} => @unimplemented
    }
  end

  def valid?(rules, event_name) when is_binary(event_name) do
    valid?(rules, String.to_atom(event_name))
  end

  def valid?(_rules, nil) do
    false
  end

  def valid?(rules, event_name) when is_atom(event_name) do
    rules
    |> Map.keys()
    |> Enum.map(fn tuple -> elem(tuple, 1) end)
    |> Enum.find(fn event -> event == event_name end)
    |> case do
      nil -> false
      _ -> true
    end
  end

  def validate!(event_name) do
    unless valid?(transition_rules(), event_name) do
      raise "Invalid event (#{event_name}), not listed in #{__MODULE__}"
    end

    true
  end
end
