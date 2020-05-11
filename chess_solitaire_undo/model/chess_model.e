note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	CHESS_MODEL

inherit
	ANY
		redefine
			out
		end

create {CHESS_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create start.make_from_string ("Game being Setup...")
			create error.make_empty
			create board.make
			create move_board.make_filled (".",4, 4)
			create print_board.make_from_string (board.out)
			create final_piece_error.make_empty
			create empty.make
			last_two_flag := 0
			num_pieces := 0

			create history.make
--			state := 0
		end

feature -- model attributes
	start: STRING
	error: STRING
	print_board: STRING
	last_two_flag : INTEGER
	final_piece_error : STRING

	empty : EMPTY_PIECE
	board : CHESS_BOARD
	move_board: ARRAY2[STRING]
	num_pieces: INTEGER

	history : HISTORY
--	state : INTEGER

feature -- model operations

	set_error (msg: STRING)
		do
			error := msg
		end

	setup_chess (c: CHESS_PIECES ; row: INTEGER ; col: INTEGER)
			--Setting up each piece on the board
		do
				board.board.put (c, row, col)
				print_board.make_from_string (board.out)
				num_pieces := num_pieces + 1
		end

	setup_chess_undo (c: CHESS_PIECES ; row: INTEGER ; col: INTEGER)
			--Setting up each piece on the board
		do
				setup_chess (c, row, col)
				print_board.make_from_string (board.out)
				num_pieces := num_pieces - 2
		end

	moves (row: INTEGER; col: INTEGER)
		local
			piece : CHESS_PIECES
		do
			piece := board.board.item (row, col)
			piece.move (move_board, row, col)
			if last_two_flag = 0 then
				print_board.make_from_string (print_moves)
			end

		end

	move_and_capture (r1: INTEGER; c1: INTEGER; r2:INTEGER; c2:INTEGER)
		local
			pieces : CHESS_PIECES
			queen_blocked : QUEEN
			bishop_blocked : BISHOP
			rook_blocked : ROOK
			knight_blocked : KNIGHT
			path : ARRAY[TUPLE[INTEGER,INTEGER]]
			skip : INTEGER
			blocked : BOOLEAN

			m_a_c_command : MOVE_AND_CAPTURE_COMMAND

		do
			create path.make_empty
			create m_a_c_command.make (r1, c1, r2, c2,error,start)

			if board.board.item (r1, c1).piece ~ "Q" then
				create queen_blocked.make
				queen_blocked.move (move_board, r1, c1)
				if possible_capture(r1,c1,r2,c2) then
					path.make_from_array (queen_blocked.move_and_capture_path(r1,c1,r2,c2))
				elseif last_two_flag = 1 then
					final_piece_error:= "0"
				else
					set_error("Error: Invalid move of Q from (" + r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")")
--					final_piece_error:= "0"
				end
			elseif board.board.item (r1, c1).piece ~ "B"  then
				create bishop_blocked.make
				bishop_blocked.move (move_board, r1, c1)
				if possible_capture(r1,c1,r2,c2) then

					path.make_from_array (bishop_blocked.move_and_capture_path(r1,c1,r2,c2))
				elseif last_two_flag = 1 then
					final_piece_error:= "0"
				else
					set_error("Error: Invalid move of B from (" + r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")")
--					final_piece_error:= "0"
				end
			elseif board.board.item (r1, c1).piece ~ "R" then
				create rook_blocked.make
				rook_blocked.move (move_board, r1, c1)
				if possible_capture(r1,c1,r2,c2) then
					path.make_from_array (rook_blocked.move_and_capture_path(r1,c1,r2,c2))
				elseif last_two_flag = 1 then
					final_piece_error:= "0"
				else
					set_error("Error: Invalid move of R from (" + r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")")
--					final_piece_error:= "0"
				end
			elseif board.board.item (r1, c1).piece ~ "N" then
				create knight_blocked.make
				knight_blocked.move (move_board, r1, c1)
				if possible_capture(r1,c1,r2,c2) then
					path.make_from_array (knight_blocked.move_and_capture_path(r1,c1,r2,c2))
				elseif last_two_flag = 1 then
					final_piece_error:= "0"
				else
					set_error("Error: Invalid move of N from (" + r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")")
--					final_piece_error:= "0"
				end
			elseif board.board.item (r1, c1).piece ~ "K" then
				pieces := board.board.item (r1, c1)
				pieces.move (move_board, r1, c1)
				if possible_capture(r1,c1,r2,c2) then
					if last_two_flag = 1 then
						final_piece_error:= "1";
					end
				elseif last_two_flag = 1 then
					final_piece_error:= "0"
				else
					set_error("Error: Invalid move of K from (" + r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")")
--					final_piece_error:= "0"
				end
			elseif board.board.item (r1, c1).piece ~ "P" then
				pieces := board.board.item (r1, c1)
				pieces.move (move_board, r1, c1)
				if possible_capture(r1,c1,r2,c2) then
					if last_two_flag = 1 then
						final_piece_error:= "1"
					end
				elseif last_two_flag = 1 then
					final_piece_error:= "0"
				else
					set_error("Error: Invalid move of P from (" + r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")")
				end
			end


			across
				path.lower |..| path.upper is i
			loop
				if (r2 = path[i].integer_item (1) and c2 = path[i].integer_item (2)) then
					skip := 1
				elseif (skip /= 1 and (not blocked)) then
					blocked := not board.unoccupied_cordinate (path[i].integer_item (1), path[i].integer_item (2))
				end

			end

				if (blocked) and last_two_flag = 0 then
					set_error("Error: Block exists between ("+r1.out+", "+c1.out+") and ("+r2.out+", "+c2.out+")")
				elseif (blocked) and last_two_flag = 1 then
					final_piece_error := "3"
				elseif last_two_flag = 0 and error.is_empty then
				--	capture_piece(r1,c1,r2,c2)
					m_a_c_command.execute
--					m_a_c_command.set_error (error)
--					m_a_c_command.set_start (start)
					history.history.force (m_a_c_command)
					history.history.finish
				end


			if num_pieces > 1 and last_two_flag = 0 and then (not possible_game) then
				start := "Game Over: You Lose!"
				error.make_empty
			end

--			if num_pieces = 1 then
--				start := "Game Over: You Win!"
--			end
		end

	move_and_capture_undo (capturing_piece: CHESS_PIECES; captured_piece: CHESS_PIECES; r1: INTEGER; c1: INTEGER; r2:INTEGER; c2:INTEGER)
		do
			setup_chess (capturing_piece, r1, c1)
			setup_chess (captured_piece, r2, c2)
			print_board.make_from_string (board.out)
			error.make_empty
			num_pieces := num_pieces - 1
		end

	start_game
		do
			if num_pieces = 0 then
				start := "Game Over: You Lose!"
			elseif num_pieces = 1 then
				start := "Game Over: You Win!"
			elseif (not possible_game) then
					start:= "Game Over: You Lose!"
					error.make_empty
--				end
			else
				error.make_empty
				start := "Game In Progress..."
			end

		end

	undo
		do
			if history.on_item then
				history.item.undo
				history.history.back
			else
				set_error ("Error: Nothing to undo")
			end
		end

	redo
		do
			if not history.history.is_empty then
				if not history.history.islast then --or not history.history.is_empty then
					if not history.is_last then
						history.history.forth
						history.item.redo
					else
						set_error("Error: Nothing to redo")
					end
				else
					set_error ("Error: Nothing to redo")
				end
			else
				set_error ("Error: Nothing to redo")
			end

		end

	reset_game
		do
			board.make
			start := "Game being Setup..."
			num_pieces := 0
			last_two_flag := 0
			final_piece_error.make_empty
			error.make_empty
			print_board.make_from_string (board.out)
		end

	reset
			-- Reset model state.
		do
			make
		end

feature --helper
	possible_capture(r1: INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			if move_board.item (r2, c2) ~ "+" then
				Result:= True

			else
				Result:= False
			end
		end

	capture_piece(r1: INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER)
		do
			board.board.put (board.board.item (r1, c1), r2, c2)
			board.board.put (empty, r1, c1)
			print_board.make_from_string (board.out)
			num_pieces := num_pieces - 1

			if num_pieces = 1 then
				start := "Game Over: You Win!"
			end

		end

	possible_game : BOOLEAN
		local
			p_moves_counter : INTEGER
			b_moves_counter : INTEGER

		do
			last_two_flag := 1
			p_moves_counter := 0
			b_moves_counter := 0

			across
				board.board.lower |..| board.board.height is i
			loop
				across
					board.board.lower |..| board.board.height is j
				loop

					if (not board.unoccupied_cordinate (i, j)) then
						moves(i,j)

						across
							board.board.lower |..| board.board.height is k
						loop
							across
								board.board.lower |..| board.board.height is l
							loop
								if (not board.unoccupied_cordinate (k, l)) then
									if (possible_capture(i,j,k,l)) then
										p_moves_counter := p_moves_counter + 1
										move_and_capture(i,j,k,l)
										if final_piece_error ~ "3" then
											b_moves_counter := b_moves_counter + 1
											final_piece_error.make_empty
										end
									end
								end

							end

						end
					end
				end
			end

			if p_moves_counter = b_moves_counter or p_moves_counter = 0 then
				last_two_flag := 0
				Result := False

			else
				last_two_flag := 0
				Result := True
			end
		end


feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("# of chess pieces on board: " + num_pieces.out)
			Result.append ("%N  ")

			if error.is_empty and (not start.is_empty) then
				Result.append (start)
				Result.append ("%N ")
				Result.append (print_board)
			else
				Result.append (error)
				Result.append ("%N ")
				Result.append (print_board)
			end
			print_board.make_from_string (board.out)
			error.make_empty
		end

	print_moves : STRING
		do
			create Result.make_from_string (" ")
			across
				move_board.lower |..| move_board.height is i
			loop
				across
					move_board.lower |..| move_board.width is j
				loop
					Result.append (move_board.item (i, j))
				end

				if (i < 4) then
					Result.append ("%N  ")
				end
			end
		end
end




