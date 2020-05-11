note
	description: "Input Handler"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_INPUT_HANDLER_INTERFACE
inherit
	ETF_TYPE_CONSTRAINTS

feature {NONE}

	make_without_running(etf_input: STRING; a_commands: ETF_ABSTRACT_UI_INTERFACE)
			-- convert an input string into array of commands
	  	do
	  		create on_error
		  	input_string := etf_input
		  	abstract_ui  := a_commands
	  	end

	make(etf_input: STRING; a_commands: ETF_ABSTRACT_UI_INTERFACE)
			-- convert an input string into array of commands
	  	do
	  		make_without_running(etf_input, a_commands)
			parse_and_validate_input_string
	  	end

feature -- auxiliary queries

	etf_evt_out (evt: TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]): STRING
		local
			etf_local_i: INTEGER
			name: STRING
			args: ARRAY[ETF_EVT_ARG]
		do
			name := evt.name
			args := evt.args
			create Result.make_empty
			Result.append (name + "(")
			from
				etf_local_i := args.lower
			until
				etf_local_i > args.upper
			loop
				if args[etf_local_i].src_out.is_empty then
					Result.append (args[etf_local_i].out)
				else
					Result.append (args[etf_local_i].src_out)
				end
				if etf_local_i < args.upper then
					Result.append (", ")
				end
				etf_local_i := etf_local_i + 1
			end
			Result.append (")")
		end

feature -- attributes

	etf_error: BOOLEAN

	input_string: STRING -- list of commands to execute

	abstract_ui: ETF_ABSTRACT_UI_INTERFACE
		-- output generated by `parse_string'

feature -- error reporting

	on_error: ETF_EVENT [TUPLE[STRING]]

feature -- error messages

	input_cmds_syntax_err_msg : STRING =
		"Syntax Error: specification of command executions cannot be parsed"

	input_cmds_type_err_msg : STRING =
		"Type Error: specification of command executions is not type-correct"

feature -- parsing

	parse_and_validate_input_string
	  local
		trace_parser : ETF_EVT_TRACE_PARSER
		cmd : ETF_COMMAND_INTERFACE
		invalid_cmds: STRING
	  do
		create trace_parser.make (evt_param_types_list, enum_items)
		trace_parser.parse_string (input_string)

	    if trace_parser.last_error.is_empty then
	  	  invalid_cmds := find_invalid_evt_trace (
		    	trace_parser.event_trace)
		  if invalid_cmds.is_empty then
		    across trace_parser.event_trace
		    as evt
		    loop
		      cmd := evt_to_cmd (evt.item)
		      abstract_ui.put (cmd)
		    end
		  else
		    etf_error := TRUE
		    on_error.notify (
		  	  input_cmds_type_err_msg + "%N" + invalid_cmds)
		  end
	    else
	      etf_error := TRUE
	      on_error.notify (
		    input_cmds_syntax_err_msg + "%N" + trace_parser.last_error)
	    end
	end

	evt_to_cmd (evt : TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]) : ETF_COMMAND_INTERFACE
		local
			cmd_name : STRING
			args : ARRAY[ETF_EVT_ARG]
			dummy_cmd : ETF_DUMMY
		do
			cmd_name := evt.name
			args := evt.args
			create dummy_cmd.make("dummy", [], abstract_ui)

			if cmd_name ~ "setup_chess" then 
				 if attached {ETF_ENUM_INT_ARG} args[1] as c and then (c.value = K or else c.value = Q or else c.value = N or else c.value = B or else c.value = R or else c.value = P) and then attached {ETF_INT_ARG} args[2] as row and then TRUE and then attached {ETF_INT_ARG} args[3] as col and then TRUE then 
					 create {ETF_SETUP_CHESS} Result.make ("setup_chess", [c.value , row.value , col.value], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "start_game" then 
				 if TRUE then 
					 create {ETF_START_GAME} Result.make ("start_game", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "reset_game" then 
				 if TRUE then 
					 create {ETF_RESET_GAME} Result.make ("reset_game", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "move_and_capture" then 
				 if attached {ETF_INT_ARG} args[1] as r1 and then TRUE and then attached {ETF_INT_ARG} args[2] as c1 and then TRUE and then attached {ETF_INT_ARG} args[3] as r2 and then TRUE and then attached {ETF_INT_ARG} args[4] as c2 and then TRUE then 
					 create {ETF_MOVE_AND_CAPTURE} Result.make ("move_and_capture", [r1.value , c1.value , r2.value , c2.value], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "moves" then 
				 if attached {ETF_INT_ARG} args[1] as row and then TRUE and then attached {ETF_INT_ARG} args[2] as col and then TRUE then 
					 create {ETF_MOVES} Result.make ("moves", [row.value , col.value], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "undo" then 
				 if TRUE then 
					 create {ETF_UNDO} Result.make ("undo", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 

			elseif cmd_name ~ "redo" then 
				 if TRUE then 
					 create {ETF_REDO} Result.make ("redo", [], abstract_ui) 
				 else 
					 Result := dummy_cmd 
				 end 
			else 
				 Result := dummy_cmd 
			end 
		end

	find_invalid_evt_trace (
		event_trace: ARRAY[TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]])
	: STRING
	local
		loop_counter: INTEGER
		evt: TUPLE[name: STRING; args: ARRAY[ETF_EVT_ARG]]
		cmd_name: STRING
		args: ARRAY[ETF_EVT_ARG]
		evt_out_str: STRING
	do
		create Result.make_empty
		from
			loop_counter := event_trace.lower
		until
			loop_counter > event_trace.upper
		loop
			evt := event_trace[loop_counter]
			evt_out_str := etf_evt_out (evt)

			cmd_name := evt.name
			args := evt.args

			if cmd_name ~ "setup_chess" then 
				if NOT( ( args.count = 3 ) AND THEN attached {ETF_ENUM_INT_ARG} args[1] as c and then (c.value = K or else c.value = Q or else c.value = N or else c.value = B or else c.value = R or else c.value = P) and then attached {ETF_INT_ARG} args[2] as row and then TRUE and then attached {ETF_INT_ARG} args[3] as col and then TRUE) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"setup_chess(c: CHESS = {K, Q, N, B, R, P} ; row: INTEGER_32 ; col: INTEGER_32)")
				end

			elseif cmd_name ~ "start_game" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"start_game")
				end

			elseif cmd_name ~ "reset_game" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"reset_game")
				end

			elseif cmd_name ~ "move_and_capture" then 
				if NOT( ( args.count = 4 ) AND THEN attached {ETF_INT_ARG} args[1] as r1 and then TRUE and then attached {ETF_INT_ARG} args[2] as c1 and then TRUE and then attached {ETF_INT_ARG} args[3] as r2 and then TRUE and then attached {ETF_INT_ARG} args[4] as c2 and then TRUE) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"move_and_capture(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)")
				end

			elseif cmd_name ~ "moves" then 
				if NOT( ( args.count = 2 ) AND THEN attached {ETF_INT_ARG} args[1] as row and then TRUE and then attached {ETF_INT_ARG} args[2] as col and then TRUE) then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"moves(row: INTEGER_32 ; col: INTEGER_32)")
				end

			elseif cmd_name ~ "undo" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"undo")
				end

			elseif cmd_name ~ "redo" then 
				if FALSE then 
					if NOT Result.is_empty then
						Result.append ("%N")
					end
					Result.append (evt_out_str + " does not conform to declaration " +
							"redo")
				end
			else
				if NOT Result.is_empty then
					Result.append ("%N")
				end
				Result.append ("Error: unknown event name " + cmd_name)
			end
			loop_counter := loop_counter + 1
		end
	end
end
