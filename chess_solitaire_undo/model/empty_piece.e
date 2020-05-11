note
	description: "Summary description for {KING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EMPTY_PIECE

inherit
	CHESS_PIECES

create
	make
--feature -- atribtues
--	empty: STRING
	--move_board: CHESS_BOARD

feature --constructor
	make
		do
			piece := "."
		end

	move (move_board: ARRAY2[STRING]; row : INTEGER; col : INTEGER)
--	move (row:INTEGER; col:INTEGER)
		do
		end

end
