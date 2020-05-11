note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	CHESS_MODEL_ACCESS

feature
	m: CHESS_MODEL
		once
			create Result.make
		end

invariant
	m = m
end




