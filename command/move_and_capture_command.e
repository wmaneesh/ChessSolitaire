note
	description: "Summary description for {MOVE_AND_CAPTURE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE_AND_CAPTURE_COMMAND

inherit
	COMMAND

create
	make

feature --Attributes
	capturing_piece : CHESS_PIECES
	captured_piece: CHESS_PIECES
	error: STRING
	start: STRING

	r1 : INTEGER
	c1 : INTEGER
	r2 : INTEGER
	c2 : INTEGER


feature --constructor
	make (row_1 : INTEGER; col_1: INTEGER; row_2: INTEGER; col_2: INTEGER; e : STRING; s: STRING)
		do
			r1 := row_1
			c1 := col_1
			r2 := row_2
			c2 := col_2

			create error.make_from_string(e)
			create start.make_from_string(s)

			capturing_piece := model.m.board.board.item (r1, c1)
			captured_piece := model.m.board.board.item (r2, c2)

		end

feature
	set_start(s: STRING)
		do
			start := s
		end
	set_error(e: STRING)
		do
			error:= e
		end

feature --commands
	execute
		do
			model.m.capture_piece (r1, c1, r2, c2)
		end

	undo
		do
			if model.m.board.board.item (r1, c1).piece ~ model.m.empty.piece then
				model.m.move_and_capture_undo (capturing_piece, captured_piece, r1, c1, r2, c2)
				model.m.set_error (error)
				model.m.start.make_from_string (start)
			end
		end

	redo
		do
			execute
		end

end
