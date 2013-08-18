defmodule Chat.UserHandler.Test do
  use ExUnit.Case
	use Proper.Properties

	test "run" do
		{_, failures} = Proper.run __MODULE__
		assert length(failures) == 0
	end

	property ".user returns user id" do
		forall x in integer do
			{:ok, pid} = Chat.UserHandler.start_link x
			Chat.UserHandler.user(pid) == x
		end
	end

	property ".change_user changes user id" do
		forall x in integer do
			{:ok, pid} = Chat.UserHandler.start_link x
			new_id = :random.uniform(100)
			Chat.UserHandler.change_user pid, new_id
			Chat.UserHandler.user(pid) == new_id
		end
	end
end
