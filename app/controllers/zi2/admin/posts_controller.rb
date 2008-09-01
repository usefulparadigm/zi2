class Zi2::Admin::PostsController < Zi2::Admin::AdminController

	PER_PAGE = 10

  def index
  	filters = ConditionFilter.new
  	if category_id = params[:category_id]
  		@category = Category.find(category_id)
  		categories = @category.self_and_descendants.map(&:id)
  		filters << ['category_id IN (?)', categories] 
  	end
		if board_id = params[:board_id]
  		filters << ['board_id =?', board_id]  
		end
  	order = 'sticky DESC, created_at DESC'
  	order = [params[:sort], order].join(',') unless params[:sort].blank?

		unless params[:q].blank?
			all_posts = Post.search(params[:q], nil,
															:select => 'id, category_id', 
															:conditions => filters.to_s) 
			@posts = Post.paginate_search(params[:q], nil, 
																		:conditions => filters.to_s,
																		:order => order, 
																		:page => params[:page], :per_page => PER_PAGE) 
		else
	  	all_posts = Post.all(:select => 'id, category_id', :conditions => filters.to_s)
	    @posts = Post.paginate(:all, 
														 :per_page => PER_PAGE, :page => params[:page],
			    									 :conditions => filters.to_s, :order => order)
		end			
		@categories = Category.fetch_all(all_posts)	 
  	@post_total = all_posts.size #Post.count(:conditions => conditions)
  	respond_to do |format| 
      format.html { render :template => 'posts/index' } # index.html.erb
      format.rss  #{ render :xml => @post }
		end
	end

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

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id], :include => :comments)
		@post.increment!(:read_count)		

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = current_user.posts.new(params[:post])
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = current_user.posts.find(params[:id])
    @post.send("#{params[:event]}!") if params[:event]

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def digg
		@post = Post.find(params[:id])
		@post.digg! request.remote_addr, current_user
		redirect_to :back  	
	end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def get_project
  	@project = params[:project]
  	@projects = Project.find(:all)
	end
  
end
