note
	description: "Summary description for {KING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	KING

inherit
	CHESS_PIECES

create
	make

--feature -- atribtues
--	k: CHESS_PIECES
--	--move_board: CHESS_BOARD
feature


feature --constructor
	make
		do
			--create piece.make_empty
			piece := "K"
		end

feature

	move(move_board: ARRAY2[STRING]; row: INTEGER; col: INTEGER)
		do
		move_board.make_filled (".", 4, 4)

			across
				(row -1) |..| (row +1) is i
			loop
				across
					(col -1) |..| (col +1) is j
				loop
					if valid_coordinates(i, j) then
						move_board.put ("+", i, j)
					end
						move_board.put (piece, row, col)
				end
			end
		end

end
