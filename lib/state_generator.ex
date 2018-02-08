defmodule EventFsm.StateGenerator do
  alias EventFsm.Evt 
  alias EventFsm.Action

  def transition_rules() do
    %{
      {:locked, :coin_deposited} =>
        {:unlocked, [Action.indicator(:green_light), Action.turnstyle(:unlock)]},
      {:unlocked, :turned_once} =>
        {:locked,
         [Action.indicator(:red_light), Action.turnstyle(:lock), Action.coin_acceptor(:clear)]},
      {:any, :any} => @unimplemented
    }
  end

  def gen_uml() do
    rules = transition_rules()
    base_dir = "gen"
    File.mkdir_p(base_dir)
    file_name = "States"
    rule_list = Map.to_list(rules) 
    io_list = stream_gen(rule_list, file_name)
    file = File.open!("gen/#{file_name}.txt", [:utf8, :write])
    write(file, io_list)
    File.close(file)
  end

  def write(file, lines) do
    lines
    |> Enum.map(fn line -> IO.puts(file, line) end)
  end

  def stream_gen(rules, image_name) do
    io_list = []
    io_list = gen_uml_header(io_list, image_name)
    steps = Enum.map(rules, fn step -> gen_uml_step([], step) end)

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
        "scale 350 width",
        "[*] --> locked"
      ]
  end

  def gen_uml_footer(io_list) do
    io_list ++ ["@enduml"]
  end

  def gen_uml_step(io_list, {{state, event}, {to_state, _actions}}) do
    io_list ++ ["#{state} --> #{to_state} : #{event}"]
  end

  # Skip for now
  def gen_uml_step(io_list, {{:any, _ }, _}) do 
    io_list 
  end
  
  # REPORT
  def gen_uml_step(io_list, param) do
    raise inspect param  
  end
end
