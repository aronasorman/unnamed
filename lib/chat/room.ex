defmodule Chat.Room do
	use GenServer.Behaviour

	defrecord State, messages: :queue.new, users: []

	def start_link(users) do
		:gen_server.start_link __MODULE__, users, []
	end

	def users(pid) do
		:gen_server.call pid, :users
	end

	def messages(pid) do
		:gen_server.call pid, :messages
	end

	def send_message(pid, from, message) do
		:gen_server.cast pid, { :send_message, Chat.Message[from_id: from, content: message]}
	end

	# callbacks
	def init(users) do
		{ :ok, State[users: users]}
	end

	def handle_call(:users, _from, state) do
		{ :reply, state.users, state}
	end

	def handle_call(:messages, _from, state) do
		{ :reply, :queue.to_list(state.messages), state}
	end

	def handle_call(req, _from, state) do
		{ :stop, "No valid handle for message #{req}", state}
	end

	def handle_cast({:send_message, message}, state) do
		state = state.update_messages(fn(q) -> :queue.in message, q end)
		{ :noreply, state }
	end

	def handle_cast(req, state) do
		{ :stop, "No valid handle for message #{req}", state}
	end
end
