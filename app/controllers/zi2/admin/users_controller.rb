class Zi2::Admin::UsersController < UsersController
	layout 'admin'
	def index
		@users = User.all
	end
end
