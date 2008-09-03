class Zi2::Admin::GroupsController < Zi2::Admin::AdminController
	PER_PAGE = 10

  make_resourceful do
    actions :all

    after :create do 
      flash[:notice] = "\"#{@group.title}\" 그룹이 생성되었습니다."
    end
    response_for :create, :update, :destroy do |format|
      format.html { redirect_to admin_groups_url }
    end
  end

  def current_objects
  	order = 'created_at'
  	order = [params[:sort], order].join(',') unless params[:sort].blank?
    @current_object ||= current_model.paginate(:all,
      :order => order, :page => params[:page], :per_page => PER_PAGE )
  end
end
