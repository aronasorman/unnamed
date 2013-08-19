defmodule Chat.UserHandler.Test do
  use ExUnit.Case
	use Proper.Properties

	test "properties" do
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

defmodule Chat.Room.Test do
	use ExUnit.Case
	use Proper.Properties

	test "properties" do
		{_, failures} = Proper.run __MODULE__
		assert length(failures) == 0
	end

	property "stores user ids" do
		forall list in list(integer) do
			{:ok, pid} = Chat.Room.start_link list
			Chat.Room.users(pid) == list
		end
	end

	property "stores messages" do
		forall {from, message} in {pos_integer, bitstring} do
			{:ok, pid} = Chat.Room.start_link [1,2]
			Chat.Room.send_message(pid, from, message)
			Chat.Room.messages(pid) == [Chat.Message[from_id: from, content: message]]
		end
	end
end