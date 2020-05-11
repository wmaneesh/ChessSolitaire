note
	description: "Summary description for {SETUP_CHESS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SETUP_CHESS_COMMAND

inherit
	COMMAND

create
	make

feature --Attributes
	r1: INTEGER
	c1: INTEGER
	empty : EMPTY_PIECE
	error : STRING
	start : STRING

	piece : CHESS_PIECES

feature --constructor
	make (p : CHESS_PIECES; r_1: INTEGER; c_1: INTEGER; e: STRING; s: STRING)
		do
			create empty.make
			create error.make_from_string (e)
			create start.make_from_string (s)
			r1:= r_1
			c1:= c_1

			piece := p
		end

feature --Commands
	execute
		do
			model.m.setup_chess (piece, r1, c1)
		end

	undo
		do
			model.m.setup_chess_undo (empty, r1, c1)
			model.m.set_error (error)
			model.m.start.make_from_string (start)
		end

	redo
		do
			execute

		end
end
