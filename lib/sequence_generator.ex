defmodule EventFsm.SequenceGenerator do
  alias EventFsm.Evt 
  alias EventFsm.Action

  def gen_uml(workflow, file_name) when is_list(workflow) do
    base_dir = "gen/workflows"
    File.mkdir_p(base_dir)
    list = String.split("#{file_name}", " ")
    file_name = Enum.take(list, -1)
    io_list = stream_gen(workflow, file_name)
    file = File.open!("gen/workflows/#{file_name}.txt", [:utf8, :write])
    write(file, io_list)
    File.close(file)
  end

  def write(file, lines) do
    lines
    |> Enum.map(fn line -> IO.puts(file, line) end)
  end

  def stream_gen(workflow, image_name) do
    io_list = []
    io_list = gen_uml_header(io_list, image_name)
    steps = Enum.map(workflow, fn step -> gen_uml_step([], step) end)

    io_list =
      steps
      |> Enum.reduce(io_list, fn step, acc -> acc ++ step end)
      |> List.flatten()

    _io_list = gen_uml_footer(io_list)
  end

  def gen_uml_header(io_list, image_name) do
    io_list ++
      [
        "@startuml",
        "title #{image_name}",
        "participant CoinAcceptor",
        "participant EventFsm",
        "participant Turnstyle",
        "participant Indictor"
      ]
  end

  def gen_uml_footer(io_list) do
    io_list ++ ["@enduml"]
  end

  def gen_uml_step(io_list, {event, actions}) do
    incoming_events =
      event
      |> event_description()
      |> List.flatten()

    io_list = io_list ++ incoming_events
    actions = actions |> List.flatten()
    action_strings = Enum.map(actions, fn action -> gen_uml_action(action) end)

    _io_list =
      action_strings
      |> Enum.reduce(io_list, fn action_string, acc -> acc ++ [action_string] end)
      |> List.flatten()
  end

  def gen_uml_action(action) do
    outgoing_actions = action_description(action)
    outgoing_actions |> List.flatten()
  end

  # --- event_description ---  

  # def event_description(%Evt{name: name, source: "POS"}) do
  #   [ "POS -> SDK : #{json_name(name)}" ]
  # end

  def event_description(%Evt{name: event_name, source: source}) do
    ["#{source} -> EventFsm : #{event_name}"]
  end

  def json_name(name_atom) do
    name = Atom.to_string(name_atom)
    camelized = Macro.camelize(name)
    first = String.at(camelized, 0)
    first_down = String.downcase(first)
    String.replace_prefix(camelized, first, first_down)
  end

  # --- action_description ---  

  def action_description(%Action{name: :store}) do
    # do not show :store action in sequence diagram
    []
  end

  def action_description(%Action{name: action_name, target: target}) do
    ["EventFsm -> #{target} : #{action_name}"]
  end
end
