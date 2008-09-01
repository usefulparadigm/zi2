module Zi2::GbpHelper 
  #def g_path(group=nil); url_for(:controller => get_group(group), :action => 'list') end
  #def gb_path(board); url_for(:controller => board.group.to_s, :board => board.to_s, :action => 'index') end
  #def new_gbp_path(board); url_for(:controller => board.group.to_s, :board => board.to_s, :action => 'new') end
  #def gbp_path(post); url_for(:controller => post.group.to_s, :board => post.board.to_s, :id => post.id, :action => 'show') end
  #def edit_gbp_path(post); url_for(:controller => post.group.to_s, :board => post.board.to_s, :id => post.id, :action => 'edit') end

  def g_path(group=nil); "/#{get_group(group)}" end
  def gb_path(board); "/#{board.group.name}/#{board.name}" end
  def new_gbp_path(board); "/#{board.group.name}/#{board.name}/new" end
  def gbp_path(post); "/#{post.group.name}/#{post.board.name}/#{post.id}" end
  def edit_gbp_path(post); "/#{post.group.name}/#{post.board.name}/#{post.id}/edit" end
  
private
  def get_group(group); group ? group.name : controller.controller_name end
end  