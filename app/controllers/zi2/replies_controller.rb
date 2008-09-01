class Zi2::RepliesController < ApplicationController
	before_filter :get_post 

	def create
		@reply = @post.replies.build(params[:reply])
		@reply.ip = request.remote_addr
		@reply.user = current_user if logged_in?
		@reply.save
		redirect_to gbp_path(@post) + "#reply_#{@reply.id}"
	end
	
private
	def get_post
		@post ||= Post.find(params[:post_id])
	end
end