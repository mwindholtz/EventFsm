defmodule Mix.Tasks.EventFsm.Gen.Sequence do
  @moduledoc """
    Generates the text file specification for the workflow sequence diagrams 
  """
  require Logger
  use Mix.Task
  # alias Mix.Tasks.EventFsm.Gen.Sequence

  @dir      "gen/workflows" 
  @tmp_dir  "gen/workflows/png" 
  @out_dir  "docs"

  @shortdoc "Generate the sequence diagrams in gen/workflows"
  def run([]) do
    gen_all(@dir)
  end

  def run([spec_number| _]) do
    {:ok, files} = File.ls(@dir) 
    regex = ~r/W#{spec_number}.*\.txt$/
    files = Enum.filter( files, fn(file_name) ->  Regex.match?(regex, file_name)  end)
    run_files(files)
  end

  def run_files([]) do
    Logger.info("No Files Found")
  end

  def run_files(files) do
    [ one_file_name | _ ] = files
    file_spec = "#{@dir}/#{one_file_name}"
    gen_one(file_spec)
    [ base_name, _ ] = String.split(one_file_name, ".")

    png = "#{@out_dir}/#{base_name}.png"
    System.cmd("open", [ png ])
  end

  defp gen_all(dir) do
    {:ok, files} = File.ls(dir) 
    files = Enum.filter( files, fn(file_name) ->  Regex.match?(~r/\.txt$/, file_name)  end)
    Enum.map(files, fn(file_name) ->  gen_one("#{dir}/#{file_name}")  end)
  end


  def gen_one(file_path) do
    Logger.info("Generating sequence diagram for #{file_path}")
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