note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVES
inherit
	ETF_MOVES_INTERFACE
create
	make
feature -- command
	moves(row: INTEGER_32 ; col: INTEGER_32)
    	do

    		if model.start ~ "Game being Setup..." then
				model.set_error ("Error: Game not yet started")
			elseif model.num_pieces <= 1 or model.start ~ "Game Over: You Win!" or model.start ~ "Game Over: You Lose!" then
				model.set_error ("Error: Game already over")
			elseif (not model.board.valid_coordinates (row, col)) then
				model.set_error ("Error: (" + row.out + ", " + col.out + ") not a valid slot")
			elseif model.board.unoccupied_cordinate (row, col) then
				model.set_error ("Error: Slot @ (" + row.out + ", " + col.out + ") not occupied")
			else
				model.moves(row,col)
			end
			-- perform some update on the model state

			etf_cmd_container.on_change.notify ([Current])
    	end

end
