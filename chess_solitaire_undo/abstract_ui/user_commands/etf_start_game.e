note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_START_GAME
inherit
	ETF_START_GAME_INTERFACE
create
	make
feature -- command
	start_game
		local
			s_game : START_GAME
    	do
			create s_game.make (model.error, model.start)
    		if model.start ~ "Game In Progress..." or model.start ~ "Game Over: You Win!" or model.start ~ "Game Over: You Lose!" then
				model.set_error ("Error: Game already started")
			elseif model.start ~ "Game Over: You Win!" then
				model.set_error ("Error: Game already over")
			else
--				model.start_game
				s_game.execute
				model.history.history.force (s_game)
				model.history.history.finish
			end
			-- perform some update on the model state

			etf_cmd_container.on_change.notify ([Current])
    	end

end
