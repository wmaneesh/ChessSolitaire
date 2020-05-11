note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_RESET_GAME
inherit
	ETF_RESET_GAME_INTERFACE
create
	make
feature -- command
	reset_game
    	do

    		if model.start ~ "Game In Progress..." or model.start ~ "Game Over: You Lose!" or model.start ~ "Game Over: You Win!" then
    			model.reset_game
    			model.history.history.wipe_out
			elseif model.start ~ "Game being Setup..." then
				model.set_error ("Error: Game not yet started")
			end

			-- perform some update on the model state

			etf_cmd_container.on_change.notify ([Current])
    	end

end
