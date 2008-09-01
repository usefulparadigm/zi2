class Zi2::Admin::BoardsController < Zi2::Admin::AdminController
	PER_PAGE = 20
	
  def index
  	order = 'created_at'
  	order = [params[:sort], order].join(',') unless params[:sort].blank?
  	unless params[:group].blank?
  		@group = Group.find(params[:group], :include => :boards)
  		boards = @group.boards
		else
			boards = Board			
		end
    @boards = boards.paginate(:all, 
													 		:per_page => PER_PAGE, :page => params[:page],
		    									 		:order => order)
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @board = Board.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @board }
    end
  end

  def new
    @board = Board.new(:group_id => params[:group])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
  end

  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        flash[:notice] = '새 게시판이 생성되었습니다.'
        format.html { redirect_to(admin_boards_url) }
        #format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to(admin_boards_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.xml
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(admin_boards_url) }
      format.xml  { head :ok }
    end
  end
end
