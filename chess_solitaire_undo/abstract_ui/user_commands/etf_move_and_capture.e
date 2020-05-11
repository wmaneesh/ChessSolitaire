note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE_AND_CAPTURE
inherit
	ETF_MOVE_AND_CAPTURE_INTERFACE
create
	make
feature -- command
	move_and_capture(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)

    	do
    		if model.start ~ "Game being Setup..." then
    			model.set_error ("Error: Game not yet started")
    		elseif (model.num_pieces <= 1 or model.start ~ "Game Over: You Lose!") then
    			model.set_error ("Error: Game already over")
			elseif (not model.board.valid_coordinates (r1, c1)) then
				model.set_error ("Error: (" + r1.out + ", " + c1.out + ") not a valid slot")
			elseif (not model.board.valid_coordinates (r2, c2)) then
				model.set_error ("Error: (" + r2.out + ", " + c2.out + ") not a valid slot")
			elseif model.board.unoccupied_cordinate (r1, c1) then
				model.set_error ("Error: Slot @ (" + r1.out + ", " + c1.out + ") not occupied")
			elseif model.board.unoccupied_cordinate (r2, c2) then
				model.set_error ("Error: Slot @ (" + r2.out + ", " + c2.out + ") not occupied")
			elseif model.start ~ "Game In Progress..." then
				model.move_and_capture (r1, c1, r2, c2)
			end
			--	m_a_c.execute
			-- perform some update on the model state
			etf_cmd_container.on_change.notify ([Current])
    	end

end
