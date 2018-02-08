defmodule EventFsm.Engine do
  @moduledoc """
    Accepts events 
  """

  use GenServer

  alias EventFsm.Evt
  alias EventFsm.EventContext
  alias EventFsm.Engine
  alias EventFsm.Transducer
  alias EventFsm.Rules
  alias EventFsm.Resolver

  defstruct resolver: Resolver.new(),
            rules: Rules.transition_rules(),
            transducer: Transducer,
            state: :locked

  # Client interface

  def new(rules \\ Rules.transition_rules(), resolver \\ Resolver.new()) do
    %Engine{
      rules: rules,
      resolver: resolver
    }
  end

  def reset() do
    GenServer.call(__MODULE__, :reset)
  end

  def event(event = %Evt{}) do
    GenServer.cast(__MODULE__, {:event, event})
  end

  # Server interface 

  def init(engine = %Engine{}) do
    {:ok, engine}
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, new(), name: __MODULE__)
  end

  def handle_cast({:event, event = %Evt{}}, engine) do
    engine = process_event(engine, event)
    {:noreply, engine}
  end

  def handle_call(:reset, _from, _discard_old_engine) do
    {:reply, :ok, new()}
  end

  # ---Implementation

  @doc """
    Apply the event to the engine.
    Wrap the event in a EventContext and then pass it thru the transducer.
    The actions produced then get resolved by the resolver.
  """
  def process_event(engine, event) do
    context = generate_actions(engine, event)
    resolver = execute_actions(engine, context.actions)

    %{engine | state: context.state, resolver: resolver}
  end

  def generate_actions(engine, event) do
    engine
    |> EventContext.new()
    |> engine.transducer.event(event)
  end

  def execute_actions(engine, actions) do
    engine.resolver
    |> Resolver.exec(actions)
  end
end
