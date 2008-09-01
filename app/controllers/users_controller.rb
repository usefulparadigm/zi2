class UsersController < ApplicationController
	before_filter :login_required, :except => [:show, :new, :create]
	
  def new
  	@user = User.new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

	def edit
		@user = User.find_by_login(params[:id])
		access_denied if @user != current_user
	end

	def update
		#raise params.inspect
		@user = User.find_by_login(params[:id])
		access_denied if @user != current_user
		if @user.update_attributes(params[:user])
      redirect_to user_url(current_user.login)
      flash[:notice] = "User Profile was updated!"
    else
      render :action => 'edit'
    end
	end
	
	def show
		@user = User.find_by_login(params[:id])
  	all_posts = @user.posts #.all(:select => 'id, category_id', :conditions => conditions)
    @posts = @user.posts.paginate(:all, 
																  :per_page => 5, :page => params[:page],
					    									  :order => 'created_at DESC')
  	@post_total = all_posts.count
  	@title = (@user == current_user) ? '내' : @user.login + '님의'
	end

end
