note
	description: "Summary description for {PAWN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PAWN

inherit
	CHESS_PIECES

create
	make

feature
	make
		do
			piece := "P"
		end

feature
	move (move_board: ARRAY2[STRING]; row:INTEGER; col:INTEGER)
		do
			move_board.make_filled (".", 4, 4)
			
			if valid_coordinates((row-1), (col-1)) then
				move_board.put ("+", (row-1), (col-1))
			end

			if valid_coordinates((row-1), (col+1)) then
				move_board.put ("+", (row-1), (col+1))
			end

				move_board.put (piece, row, col)

		end

end
