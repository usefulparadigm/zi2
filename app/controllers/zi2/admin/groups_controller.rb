class Zi2::Admin::GroupsController < Zi2::Admin::AdminController
	PER_PAGE = 10
	
  def index
  	order = 'created_at DESC'
  	order = [params[:sort], order].join(',') unless params[:sort].blank?
    @groups = Group.paginate(:all, 
														 :per_page => PER_PAGE, :page => params[:page],
			    									 :order => order)
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = "\"#{@group.title}\" 그룹이 생성되었습니다."
      redirect_to admin_groups_url 
    else
			render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:notice] = 'Board was successfully updated.'
      redirect_to admin_groups_url 
    else
			render :action => "edit" 
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
		redirect_to(admin_groups_url) 
  end
end
