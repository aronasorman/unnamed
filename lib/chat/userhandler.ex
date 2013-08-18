defmodule Chat.UserHandler do
	use GenServer.Behaviour

	defrecord State, user_id: -1

	def start_link(user_id) do
		:gen_server.start_link __MODULE__, user_id, []
	end

	def change_user(pid, user_id) do
		:gen_server.cast pid, {:change_user, user_id}
	end

	def user(pid, timeout // 5000) do
		:gen_server.call pid, :user, timeout
	end

	# callbacks
	def init(user_id) do
		{ :ok, State[user_id: user_id]}
	end

	def handle_call(:user, _from, state) do
		{:reply, state.user_id, state}
	end

	def handle_cast({:change_user, user_id}, state) do
		{ :noreply, state.user_id user_id}
	end
end