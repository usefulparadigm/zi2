class Zi2::Admin::UsersController < Zi2::Admin::AdminController
  PER_PAGE = 3

	def index
		@users = User.all.paginate :page => params[:page], :per_page => PER_PAGE
	end
	
end
