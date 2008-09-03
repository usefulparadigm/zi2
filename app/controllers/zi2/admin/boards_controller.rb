class Zi2::Admin::BoardsController < Zi2::Admin::AdminController
	PER_PAGE = 20

  make_resourceful do
    actions :all
    
    before :new do
      current_object.group_id = params[:group]
    end
    after :create do 
      flash[:notice] = '새 게시판이 생성되었습니다.'
    end
    response_for :create, :update, :destroy do |format|
      format.html { redirect_to(admin_boards_url) }
    end
  end

  def current_objects
  	order = 'created_at'
  	order = [params[:sort], order].join(',') unless params[:sort].blank?
  	unless params[:group].blank?
  		@group = Group.find(params[:group], :include => :boards)
  		boards = @group.boards
		else
			boards = Board			
		end
    @current_object ||= boards.paginate(:all, 
													 		:per_page => PER_PAGE, :page => params[:page],
		    									 		:order => order)
  end
end
