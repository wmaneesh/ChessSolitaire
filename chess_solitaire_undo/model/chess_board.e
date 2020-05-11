note
	description: "Summary description for {CHESS_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHESS_BOARD

inherit
	ANY
		redefine out end

create
	make

feature --Attributes
	board: ARRAY2[CHESS_PIECES]
	empty : EMPTY_PIECE


feature
	make
		do	create empty.make
			create board.make_filled (empty,4, 4)
		end


feature --command
	capture(c: CHESS_PIECES; r1: INTEGER;  c1: INTEGER; r2: INTEGER; c2: INTEGER)
		do
			board.put (empty, r1, c1)
			board.put (c, r2, c2)
		end


feature -- helper
	unoccupied_cordinate (r1: INTEGER ; c1: INTEGER) : BOOLEAN
		do
			Result:= board.item (r1, c1).piece ~ empty.piece
		end

	valid_coordinates (r1: INTEGER ; c1: INTEGER) : BOOLEAN
		do
			Result := (r1 > 0 and r1 < 5) and then (c1 > 0 and c1 < 5)
		end

	item_at(row:INTEGER; col:INTEGER): STRING
		do
			Result:= board.item (row, col).piece

		end



feature --output
	out: STRING
		do
			create Result.make_from_string (" ")

			across
				board.lower |..| board.height is i
			loop
				across
					board.lower |..| board.width is j
				loop
					if board.item (i, j) /~ empty then
						Result.append (item_at (i, j))
					else
						Result.append (".")
					end
				end
				if (i < 4) then
					Result.append ("%N  ")
				end
			end
		end

end
