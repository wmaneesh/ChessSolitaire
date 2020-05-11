note
	description: "Summary description for {COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMMAND

feature --attributes
	model : CHESS_MODEL_ACCESS
	
feature --commands
	execute
		deferred
		end

	undo
		deferred
		end

	redo
		deferred
		end
end
