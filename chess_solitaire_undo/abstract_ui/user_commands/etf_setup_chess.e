note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_CHESS
inherit
	ETF_SETUP_CHESS_INTERFACE
create
	make
feature -- command
	setup_chess(c: INTEGER_32 ; row: INTEGER_32 ; col: INTEGER_32)
		require else
			setup_chess_precond(c, row, col)
		local
			chess_piece: ETF_TYPE_CONSTRAINTS
			King : KING
			Queen : QUEEN
			Bishop : BISHOP
			Rook : ROOK
			Night : KNIGHT
			Pawn : PAWN
			empty : EMPTY_PIECE
			s_chess : SETUP_CHESS_COMMAND
    	do
    		--create s_chess.make (c, row, col)

    		if model.start /~ "Game being Setup..." then
    			model.set_error ("Error: Game already started")
    		elseif (not model.board.valid_coordinates (row, col)) then
				model.set_error ("Error: (" + row.out + ", " + col.out + ") not a valid slot")
    		elseif (not model.board.unoccupied_cordinate (row, col)) then
				model.set_error ("Error: Slot @ (" + row.out + ", " + col.out + ") already occupied")
			else
					create chess_piece
				if chess_piece.k ~ c then
					create King.make
					--board.put (K, row, col)
					create s_chess.make (King, row, col, model.error, model.start)
				elseif chess_piece.q ~ c then
					create Queen.make
					--board.put (Q, row, col)
					create s_chess.make (Queen, row, col, model.error, model.start)
				elseif chess_piece.b ~ c then
					create Bishop.make
					--board.put (B, row, col)
					create s_chess.make (Bishop, row, col, model.error, model.start)
				elseif chess_piece.r ~ c then
					create Rook.make
					--board.put (R, row, col)
					create s_chess.make (Rook, row, col, model.error, model.start)
				elseif chess_piece.N ~ c then
					create Night.make
					--board.put (N, row, col)
					create s_chess.make (Night, row, col, model.error, model.start)
				elseif chess_piece.P ~ c then
					create Pawn.make
					--board.put (P, row, col)
					create s_chess.make (Pawn, row, col, model.error, model.start)
				else
					create empty.make
					--board.put (empty, row, col)
					create s_chess.make (empty, row, col, model.error, model.start)
				end
--				if not model.history.history.islast then
--					model.history.remove_all_right
--				end

				s_chess.execute
				model.history.history.force (s_chess)
				model.history.history.finish



    			--model.setup_chess (c, row, col)
    		end
			-- perform some update on the model state
			etf_cmd_container.on_change.notify ([Current])
    	end

end
