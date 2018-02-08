defmodule Mix.Tasks.EventFsm.Gen.State do
  @moduledoc """
    Generates the text file specification for the workflow sequence diagrams 
  """
  require Logger
  use Mix.Task
  # alias Mix.Tasks.EventFsm.Gen.Sequence

  @dir      "gen/" 
  @tmp_dir  "gen/png" 
  @out_dir  "docs"

  @shortdoc "Generate the state diagrams in rules"
  def run(_) do
    gen_one() 
    png = "#{@out_dir}/States.png"
    System.cmd("open", [ png ])
  end

  def gen_one() do
    file_path = "gen/States.txt" 
    Logger.info("Generating state diagram")
    System.cmd("plantuml", ["-o", "png", file_path])
    tmp_path =  
      file_path
      |> String.replace_suffix(".txt", ".png" )
      |> String.replace_prefix(@dir, @tmp_dir)
    move_to =
      String.replace_prefix(tmp_path, @tmp_dir, @out_dir)
    case  File.rename(tmp_path, move_to) do
      {:error, message } -> Logger.error("#{message} during rename FROM: #{tmp_path},  TO: #{move_to}")
      :ok                -> Logger.info(":ok, #{move_to}")
    end
  end
end