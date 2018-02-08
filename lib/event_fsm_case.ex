defmodule EventFsm.EventFsmCase do
  @moduledoc """
  Test setup for workflow Rules
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias EventFsm.Evt
      alias EventFsm.Engine
      alias EventFsm.Transducer
      alias EventFsm.EventContext
      alias EventFsm.Action, as: ShouldThen
      alias EventFsm.Rules, as: Rules

      defmodule DispatcherReflector do
        def cast_to_engine(event = %Evt{}), do: send(self(), event)
        def cast_to_indicator(event = %Evt{}), do: send(self(), event)
        def cast_to_turnstyle(event = %Evt{}), do: send(self(), event)
        def cast_to_coin_acceptor(event = %Evt{}), do: send(self(), event)
      end
    end
  end

  setup _tags do
    :ok
  end
end
