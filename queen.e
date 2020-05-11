note
	description: "Summary description for {QUEEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QUEEN

inherit
	CHESS_PIECES

create
	make

feature -- atribtues



feature
	make
		do
			piece := "Q"
		end

feature
	move (move_board: ARRAY2[STRING]; row:INTEGER; col:INTEGER)

		do
			move_board.make_filled (".", 4, 4)
			
			across
				move_board.lower |..| move_board.height is i
			loop

				if valid_coordinates((row-i), (col-i)) then --
					move_board.put ("+", (row-i), (col-i))
				end

				if valid_coordinates((row+i),(col+i)) then
					move_board.put ("+", (row+i), (col+i))
				end

				if valid_coordinates((row-i), (col+i)) then
					move_board.put ("+", (row-i), (col+i))
				end

				if valid_coordinates((row+i),(col-i)) then
					move_board.put ("+", (row+i), (col-i))
				end

					move_board.put ("+", row, i)
					move_board.put ("+", i, col)
			end

			move_board.put (piece, row, col)
		end

feature --helper
--create a helper feature to get the row and columns of the direct path to the capture piece
	move_and_capture_path (r1: INTEGER; c1:INTEGER; r2: INTEGER; c2:INTEGER) : ARRAY[TUPLE[INTEGER,INTEGER]]
		local
			position : ARRAY[TUPLE[INTEGER,INTEGER]]
			bishop_moves : BISHOP
			rook_moves : ROOK
		do
			create bishop_moves.make
			create rook_moves.make
			create position.make_empty

			if (r1/=r1) and (c1/=c2) then
				position.make_from_array (bishop_moves.move_and_capture_path (r1, c1, r2, c2))
			else
				position.make_from_array (rook_moves.move_and_capture_path (r1,c1,r2,c2))
			end

			Result:= position
		end
end
