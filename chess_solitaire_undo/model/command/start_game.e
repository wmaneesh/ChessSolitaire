note
	description: "Summary description for {START_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	START_GAME

inherit
	COMMAND

create
	make

feature --Attributes
	error : STRING
	start : STRING


feature --constructor
	make (e: STRING; s: STRING)
		do
			create error.make_from_string (e)
			create start.make_from_string (s)
		end

feature --Commands
	execute
		do
			model.m.start_game
		end

	undo
		do

			model.m.set_error (error)
			model.m.start.make_from_string (start)
		end

	redo
		do
			execute
		end
end
