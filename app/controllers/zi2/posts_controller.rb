class Zi2::PostsController < ApplicationController
  
  before_filter :login_required, :except => [:list, :index, :show, :catch_all]
  before_filter :set_group_board #, :only => [:list, :index, :new, :create]
  
  layout 'zi2/posts/inner'
  inherit_views

	PER_PAGE = 10

	# GET /group
	def list
	  real_list
	  render_to_respond('list')
	end	

	# GET	/group/board
	def index
	 	@title = @group.title + ' - ' + @board.title
 	  send(@board.name.to_sym)
 	  render_to_respond(@board.name)
  rescue
 	  real_index
 	  begin 
   	  render_to_respond(@board.name)
 	  rescue ActionView::MissingTemplate
 	    render_to_respond('index')
    end
	end

  # GET /group/board/id
  def show
    @post = Post.filter(current_user).find(params[:id], :include => :replies)
	  @post.increment!(:read_count)
  	set_group_board
  	@title = ''
  rescue ActiveRecord::RecordNotFound	
    redirect_to root_path
  end

  # GET /group/board/new
  def new
    @post = Post.new
    @post.board = @board
    @title = '새글 작성'
  end

  def edit
    @post = Post.find(params[:id])
    set_group_board
    @title = '글 수정하기'
  end

  def create
    @post = current_user.posts.new(params[:post])
    # FIXME: Add clips_count update code here...
    #@post.update_attribute :clips_count, @post.clips.count
    #@post.increment :clips_count, @post.clips.count
    if @post.save
      #flash[:notice] = 'Post was successfully created.'
      redirect_to gbp_path(@post)
    else
      set_group_board
      render :action => 'new'
    end
  end

  def update
    @post = Post.find(params[:id])
    set_group_board

    respond_to do |format|
      if @post.update_attributes(params[:post])
        #flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to gbp_path(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    set_group_board
    @post.destroy
    redirect_to gb_path(@board)
  end

	def upload
		@clip = Clip.new(:uploaded_data => params[:clip])

		respond_to do |format|
			if @clip.save
				flash[:notice] = 'Clip was successfully saved.'
				#format.html { redirect_to :back }
				format.js do
					responds_to_parent do
						render :update do |page|
							page.insert_html :bottom, 'clipList', :partial => 'clip', :object => @clip
							page << "finishUpload();"
						end
					end
				end
			else
				format.js do
					responds_to_parent do
						render :update do |page|
							# update page with error message!
							page << "abortUpload('#{@clip.errors}');"
						end
					end
				end
			end
		end
	end

  def digg
		@post = Post.find(params[:id])
		unless @post.digg! request.remote_addr, current_user
  	  flash[:alert] = '이미 추천한 포스트입니다!'
		end  
	  redirect_to :back  	
	end
	
	# TBD
  def search
  	unless params[:q].blank?
			all_posts = Post.search(params[:q]) 
			@post_total = all_posts.size
			@categories = Category.fetch_all(all_posts)	 
			@posts = Post.paginate_search(params[:q], nil, 
																		:order => 'updated_at DESC', 
																		:page => params[:page], :per_page => 10) 
			render :action => 'index'
		else
			redirect_to :back
		end
	end

	def catch_all
		@group_name, @board_name, @post_id = params[:path]
		unless @board_name
		  @group_name, params[:format] = $1, $2 if @group_name =~ /(.*?)\.(.*)/
		  @group = Group.find_by_name(@group_name, :include => :boards)
		  @boards = @group.boards
			real_list
			render_to_respond('list')
		else
		  @board_name, params[:format] = $1, $2 if @board_name =~ /(.*?)\.(.*)/
		  @board = Board.find_by_name(@board_name)
		  @group = @board.group	
			unless @post_id
				real_index
				render_to_respond('index')
			else
				case @post_id 
				when 'new'
				  login_only do 
				    new
				    render :action => 'new'
				  end  
				else
			    params[:id] = @post_id
			    show
			    render :action => 'show'
		    end
			end
		end		
	end

  protected

  def real_list
  	order = params[:sort] unless params[:sort].blank?
	  @posts = Post.group(@group.name).filter(current_user).paginate :per_page => PER_PAGE, :page => params[:page], :order => order
	 	@post_total = @group.boards.inject(0) { |count, board| count += board.posts_count }
	 	@title = @group.title
  end  

  def real_index
		page = params[:page] ? params[:page].to_i : 1
  	order = params[:sort] unless params[:sort].blank?
		@posts = Post.board(@board.name).filter(current_user).paginate :per_page => PER_PAGE, :page => page, :order => order
    @post_total = @board.posts_count 
		@start_no = @post_total - ((page-1) * PER_PAGE)
  end
  
  private
  
  def set_group_board
    if @post 
      @group, @board = @post.group, @post.board
    else
      @board ||= Board.find_by_name(params[:board], :include => :group) unless params[:board].blank?
      @group ||= @board ? @board.group : Group.find_by_name(controller_name)
    end
  end
  
  def render_to_respond(action_name)
    respond_to do |format|
      format.html { render :action => action_name }
      format.rss { render :layout => false, :action => 'index' }
    end
  end
end
