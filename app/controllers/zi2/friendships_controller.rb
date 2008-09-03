class Zi2::FriendshipsController < ApplicationController
	before_filter :login_required
	before_filter :get_both_side, :except => [:index]

	# GET /users/:user_id/friendships	
	def index
		@user = User.find_by_login(params[:user_id])
		if @user == current_user
			@friends = @user.friends
			@pendings_for_me = @user.pending_friends_for_me
			@pendings_by_me = @user.pending_friends_by_me
		else
			redirect_to user_path(@user)
		end
	end

	# PUT	/users/:user_id/friendships/:id/ask	
	def ask
		@user.request_friendship_with @other
		redirect_to_index
	end
	
	# PUT	/users/:user_id/friendships/:id/accept	
	def accept
		@user.accept_friendship_with @other
		redirect_to_index
	end
	# DELETE /users/:user_id/friendships/:id	
	def destroy
		@user.delete_friendship_with @other
		redirect_to_index
	end
	
private

	def get_both_side
		#@user, @other = User.find_all_by_login([params[:user_id], params[:id]])
		@user = current_user
		@other = User.find_by_login(params[:id])
	end
	
	def redirect_to_index
		redirect_to user_friendships_path(@user)
	end
end
