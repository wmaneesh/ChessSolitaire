note
	description: "Summary description for {KNIGHT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	KNIGHT

inherit
	CHESS_PIECES

create
	make

feature -- atribtues
	two_up : ARRAY[TUPLE[INTEGER,INTEGER]]
	two_down : ARRAY[TUPLE[INTEGER,INTEGER]]
	one_up_two_right : ARRAY[TUPLE[INTEGER,INTEGER]]
	one_up_two_left : ARRAY[TUPLE[INTEGER,INTEGER]]
	one_down_two_right : ARRAY[TUPLE[INTEGER,INTEGER]]
	one_down_two_left : ARRAY[TUPLE[INTEGER,INTEGER]]



feature --constructor
	make
		do
			piece := "N"

			create two_up.make_empty
			create two_down.make_empty
			create one_up_two_right.make_empty
			create one_up_two_left.make_empty
			create one_down_two_right.make_empty
			create one_down_two_left.make_empty
		end

feature
	move (move_board: ARRAY2[STRING]; row:INTEGER; col:INTEGER)
		do
			move_board.make_filled (".", 4, 4)

			if valid_coordinates((row-1),(col-2)) then --one_up_two_left
				move_board.put ("+", (row-1), (col-2))
				one_up_two_left.force ([(row-1),(col)], one_up_two_left.count + 1)
				one_up_two_left.force ([(row-1),(col-1)], one_up_two_left.count + 1)
			end

			if valid_coordinates((row+1),(col-2)) then --one_down_two_left
				move_board.put ("+", (row+1), (col-2))
				one_down_two_left.force ([(row+1),(col)], one_down_two_left.count + 1)
				one_down_two_left.force ([(row+1),(col-1)], one_down_two_left.count + 1)
			end

			if valid_coordinates((row-1),(col+2)) then --one_up_two_right
				move_board.put ("+", (row-1), (col+2))
				one_up_two_right.force ([(row-1),(col)], one_up_two_right.count + 1)
				one_up_two_right.force ([(row-1),(col+1)], one_up_two_right.count + 1)
			end

			if valid_coordinates((row+1),(col+2)) then --one_down_two_right
				move_board.put ("+", (row+1), (col+2))
				one_down_two_right.force ([(row+1),(col)], one_down_two_right.count + 1)
				one_down_two_right.force ([(row+1),(col+1)], one_down_two_right.count + 1)
			end

			if valid_coordinates((row-2),col) then --two_up_one_left
				two_up.force ([(row-1),(col)], two_up.count + 1)
				two_up.force ([(row-2),(col)], two_up.count + 1)

				if valid_coordinates((row-2),(col-1)) then
					move_board.put ("+", (row-2), (col-1))
				end
				if valid_coordinates ((row-2),(col+1)) then
					move_board.put ("+", (row-2), (col+1))
				end
			end

			if valid_coordinates((row+2),(col)) then --two_down_one_left

				two_down.force ([(row+1),(col)], two_down.count + 1)
				two_down.force ([(row+2),(col)], two_down.count + 1)

				if valid_coordinates((row+2),(col-1)) then
					move_board.put ("+", (row+2), (col-1))
				end
				if valid_coordinates ((row+2),(col+1)) then
					move_board.put ("+", (row+2), (col+1))
				end

			end

--			if valid_coordinates((row-2),(col+1)) then --two_up_one_right
--				move_board.put ("+", (row-2), (col+1))
--			end

--			if valid_coordinates((row+2),(col+1)) then --two_down_one_right
--				move_board.put ("+", (row+2), (col+1))
--			end

			move_board.put (piece, row, col)
		end

feature --helper
--create a helper feature to get the row and columns of the direct path to the capture piece
	move_and_capture_path (r1: INTEGER; c1:INTEGER; r2: INTEGER; c2:INTEGER) : ARRAY[TUPLE[INTEGER,INTEGER]]
		local
			position : ARRAY[TUPLE[INTEGER,INTEGER]]
		do
			create position.make_empty

			if (r1-r2 = 2) then --Two up
				position.make_from_array (two_up)
			elseif (r2-r1 = 2) then --Two down
				position.make_from_array (two_down)
			elseif (r1-r2 = 1) and (c1<c2) then --One up two right
				position.make_from_array (one_up_two_right)
			elseif (r1-r2 = 1) and (c2<c1) then --one up two left
				position.make_from_array (one_up_two_left)
			elseif (r2-r1 = 1) and (c1<c2) then --one down two right
				position.make_from_array (one_down_two_right)
			elseif (r2-r1 = 1) and (c2<c1) then --one down two left
				position.make_from_array (one_down_two_left)
			end

			Result:= position
		end
end
