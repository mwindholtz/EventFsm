defmodule EventFsm.EventContext do
  @moduledoc """
   Context as Events are processed
  """

  defstruct state: :locked,
            rules: :no_rules,
            events: [],
            transitions: [],
            actions: []

  alias EventFsm.EventContext

  def new(%{rules: rules, state: state}) do
    %EventContext{rules: rules, state: state}
  end

  def transition(context, event_name, pre, post) do
    latest = {event_name, %{order: [pre, post]}}
    %{context | transitions: [latest | context.transitions]}
  end

  def add_actions(context, actions) do
    mod_actions = (context.actions ++ actions) |> List.flatten()
    %{context | actions: mod_actions}
  end

  def add_events(context, event_name) do
    %{context | events: [event_name | context.events]}
  end
end
