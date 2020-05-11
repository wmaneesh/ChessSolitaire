note
	description: "Summary description for {BISHOP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BISHOP

inherit
	CHESS_PIECES

create
	make

feature -- atribtues
	--b: STRING
	left_top : ARRAY[TUPLE[INTEGER,INTEGER]]
	right_top : ARRAY[TUPLE[INTEGER,INTEGER]]
	left_bottom : ARRAY[TUPLE[INTEGER,INTEGER]]
	right_bottom : ARRAY[TUPLE[INTEGER,INTEGER]]
	all_Moves : ARRAY[TUPLE[INTEGER,INTEGER]]

feature
	make
		do
			piece := "B"

			create left_top.make_empty
			create right_top.make_empty
			create left_bottom.make_empty
			create right_bottom.make_empty
			create all_moves.make_empty
		end

feature
	move (move_board: ARRAY2[STRING]; row:INTEGER; col:INTEGER)
		do
		move_board.make_filled (".", 4, 4)


			across
				move_board.lower |..| move_board.height is i
			loop
				if valid_coordinates((row-i), (col-i)) then --left_top
					move_board.put ("+", (row-i), (col-i))
					left_top.force ([row-i,col-i], left_top.count + 1)
				end

				if valid_coordinates((row-i), (col+i)) then --right_top
					move_board.put ("+", (row-i), (col+i))
					right_top.force ([row-i,col+i], right_top.count + 1)
				end

				if valid_coordinates((row+i),(col-i)) then --left_bottom
					move_board.put ("+", (row+i), (col-i))
					left_bottom.force ([row+i,col-i], left_bottom.count + 1)
				end

				if valid_coordinates((row+i),(col+i)) then --right_bottom
					move_board.put ("+", (row+i), (col+i))
					right_bottom.force ([row+i,col+i], right_bottom.count + 1)
				end
			end
			move_board.put (piece, row, col)
		end

feature --helper
--create a helper feature to get the row and columns of the direct path to the capture piece
	move_and_capture_path (r1: INTEGER; c1:INTEGER; r2: INTEGER; c2:INTEGER) : ARRAY[TUPLE[INTEGER,INTEGER]]
		local
			position : ARRAY[TUPLE[INTEGER,INTEGER]]
		do
			create position.make_empty
			if (r1 < r2 and c1< c2 and (c2-c1>1)) then
				position.make_from_array (right_bottom)
			elseif (r1<r2 and c1>c2 and (c1-c2>1)) then
				position.make_from_array (left_bottom)
			elseif (r1>r2 and c1<c2 and (c2-c1>1)) then
				position.make_from_array (right_top)
			elseif (r1>r2 and c1>c2 and (c1-c2>1)) then
				position.make_from_array (left_top)
			end

			Result:= position
		end
end
