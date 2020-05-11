note
	description: "Summary description for {CHESS_PIECES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CHESS_PIECES

feature
--	move_board: CHESS_BOARD
	piece : STRING

feature
	move (move_board: ARRAY2[STRING]; row: INTEGER; col: INTEGER)
--	move (row:INTEGER; col:INTEGER)
		deferred
		end
feature

	valid_coordinates (r1: INTEGER ; c1: INTEGER) : BOOLEAN
		do
			Result := (r1 > 0 and r1 < 5) and then (c1 > 0 and c1 < 5)
		end

end
