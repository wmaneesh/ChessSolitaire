note
	description: "Summary description for {ROOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROOK

inherit
	CHESS_PIECES

create
	make

feature
	h_left : ARRAY[TUPLE[INTEGER,INTEGER]]
	h_right : ARRAY[TUPLE[INTEGER,INTEGER]]
	v_up : ARRAY[TUPLE[INTEGER,INTEGER]]
	v_down : ARRAY[TUPLE[INTEGER,INTEGER]]

feature
	make
		do
			piece := "R"

			create h_left.make_empty
			create h_right.make_empty
			create v_down.make_empty
			create v_up.make_empty
		end
feature
	move (move_board: ARRAY2[STRING]; row:INTEGER; col:INTEGER)
		do
			move_board.make_filled (".", 4, 4)

			across
				move_board.lower |..| move_board.height is i
			loop
					move_board.put ("+", row, i)

					if valid_coordinates (row, col-i) then
						h_left.force ([row,col-i], h_left.count + 1)
					end

					if valid_coordinates (row, col+i) then
						h_right.force ([row,col+i],h_right.count + 1)
					end

			end

			across
			 	move_board.lower |..| move_board.height is j
			loop
					move_board.put ("+", j, col)

					if valid_coordinates (row-j, col) then
						v_up.force ([row-j,col], v_up.count + 1)
					end

					if valid_coordinates (row+j, col) then
						v_down.force ([row+j,col],v_down.count + 1)
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
			if (r1=r2) and (c1 < c2) and (c2 - c1 > 1) then --horizontally right
				position.make_from_array (h_right)
			elseif (r1=r2) and (c2 < c1) and (c1 - c2 > 1) then --horizontally left
				position.make_from_array (h_left)
			elseif (c1=c2) and (r1 < r2) and (r2 - r1 > 1) then --vertically down
				position.make_from_array (v_down)
			elseif (c1=c2) and (r2 < r1) and (r1 - r2 > 1) then --vertically up
				position.make_from_array (v_up)
			end

			Result:= position
		end

end
