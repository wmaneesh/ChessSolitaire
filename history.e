note
	description: "Summary description for {HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

create
	make

feature --Attributes
	history : LIST[COMMAND]

feature -- Construnctor
	make
		do
			create {ARRAYED_LIST[COMMAND]} history.make (0)
		end

feature -- Queries
	count : INTEGER
		do
			Result := history.count
		end

	item : COMMAND
		require
			on_item
		do
			Result:= history.item
		end

	is_first : BOOLEAN
		do
			Result:= history.before
		end

	is_last : BOOLEAN
		do
			Result:= history.after
		end

	not_last : BOOLEAN
		do
			Result:=  (not history.is_empty) and (not is_last)
		end

	on_item : BOOLEAN
		do
			Result:= (not history.is_empty) and (not history.before)
		end

	remove_all_right
--		require
--			not_last_item: (not history.after) --(not history.islast) --and
		do
--			across
--				history.forth |..| history.after is i
--			loop
--				history.forth
--				history.remove
--			end
		if (not history.islast) and (not history.after) then

		end
			from
				history.forth
			until
				history.after
			loop
				history.remove
			end
		end


end
