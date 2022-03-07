# EventFsm

** Example Event driven Finite State Machine (FSM).   Using a simple TurnStyle **

## Example Code

This is not production quality code.  This is merely an example of how to connect services with Elixir GenServers and a FSM

Here is a workflow test. It is a good place to start to trace the logic. 
https://github.com/mwindholtz/EventFsm/blob/master/test/workflow/full_cycle_test.exs

It does the following 
* tests that the workflow events function
* generates a new sequence diagram with "SequenceGenerator"
* checks to see that the currently generated instructions match the expected instructions in the fixture file. "assert_steps_match_fixture"


## Install plantuml
In order to generate the sequence diagrams for the FSM, install plantuml
*  http://plantuml.com
