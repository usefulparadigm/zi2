class Zi2::PostsController < ApplicationController
  
  before_filter :login_required, :except => [:list, :index, :show, :catch_all]
  before_filter :set_group_board #, :only => [:list, :index, :new, :create]
  
  layout 'zi2/posts/inner'
  inherit_views

	PER_PAGE = 10

	# GET /group
	def list
  	order = params[:sort] unless params[:sort].blank?
	  @posts = Post.group(@group.name).paginate :per_page => PER_PAGE, :page => params[:page], :order => order
	 	@post_total = @group.boards.inject(0) { |count, board| count += board.posts_count }
	 	@title = @group.title
	end	

	# GET	/group/board
	def index
	 	@title = @group.title + ' - ' + @board.title
 	  send(@board.name.to_sym)
 	  render :action => @board.name
  rescue
 	  real_index
 	  begin 
 	    render :action => @board.name 
 	  rescue ActionView::MissingTemplate
 	    render :action => 'index'
    end
	end

  # GET /group/board/id
  def show
    @post = Post.find(params[:id], :include => :replies)
  	@post.increment!(:read_count)		
  	set_group_board
  	@title = false
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
      flash[:notice] = 'Post was successfully created.'
      redirect_to gb_path(@post.board)
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
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to gb_path(@post.board) }
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


  # TODO: Refactoring!
	def catch_all
		@group_name, @board_name, @post_id = params[:path]
		unless @board_name
		  @group = Group.find_by_name(@group_name, :include => :boards)
		  @boards = @group.boards
			list
			render :action => 'list'
		else
		  @board = Board.find_by_name(@board_name)
		  @group = @board.group	
			unless @post_id
				real_index
				render :action => 'index'
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

  private

  def real_index
		page = params[:page] ? params[:page].to_i : 1
  	order = params[:sort] unless params[:sort].blank?
		@posts = Post.board(@board.name).paginate :per_page => PER_PAGE, :page => page, :order => order
    @post_total = @board.posts_count 
		@start_no = @post_total - ((page-1) * PER_PAGE)
  end
  
  def get_gbp
    @board ||= Board.find_by_name(params[:board]) unless params[:board].blank?
    @group ||= Group.find_by_name(controller_name, :include => :boards)
  end
  
  def set_gbp
    @post = Post.find(params[:id])
    @group, @board = @post.group, @post.board 
  end

  def set_group_board
    if @post 
      @group, @board = @post.group, @post.board
    else
      @board ||= Board.find_by_name(params[:board], :include => :group) unless params[:board].blank?
      @group ||= @board ? @board.group : Group.find_by_name(controller_name)
    end
  end

  
#  def set_group_board
#    if @post 
#      @group, @board = @post.group, @post.board
#    else
#      @group ||= Group.find_by_name(controller_name)
#      @board ||= Board.find_by_name(params[:board], :include => :group) unless params[:board].blank?
#    end
#  end

	def get_group_and_boards
		set_gbp
		@group ||= Group.find_by_name(@group_name, :include => :boards)
		@boards = @group.boards
		@title = @group.title
	end
	
	def get_board_and_group
		set_gbp
		@board ||= Board.find_by_name(@board_name, :include => :group)
		@group = @board.group
		@title = @group.title + ' - ' + @board.title
	end
	
	#def set_gbp
	#	@group_name ||= controller_name
	#	@board_name ||= params[:board] #(params[:real_action] || action_name)
	#	@post_id ||= params[:id]
	#end
  
end
