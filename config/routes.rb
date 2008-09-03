ActionController::Routing::Routes.draw do |map|

  map.resources :users
	map.resources :users do |users|
    users.resources :friendships, :member => { :ask => :put, :accept => :put }, :controller => 'zi2/friendships'
  end
  	
  map.open_id_complete 'session', :controller => 'sessions', :action => 'create', :conditions => { :method => :get }
  map.resource :session

  map.resources :boards
  map.resources :posts, #:has_many => [:replies, :clips], 
  							:collection => { :search => :get, :upload => :post }, 
  							:member => { :digg => :put },
  							:controller => 'zi2/posts' do |posts|
    posts.resources :replies, :controller => 'zi2/replies'
    #posts.recources :clips, :controller => 'zi2/clips'
  end 
  map.resources :clips, :controller => 'zi2/clips'

	map.admin 'admin', :controller => 'zi2/admin/boards'	
	map.namespace('zi2/admin', :name_prefix => 'admin_') do |admin|
	 admin.resources :posts
	 admin.resources :boards
	 admin.resources :groups
	 admin.resources :users
	 admin.resources :roles
	end
  
  map.root :controller => 'home', :action => 'list'

  map.connect ':controller.:format', :action => 'list'
  map.connect ':controller', :action => 'list'
  map.connect ':controller/:board.:format', :action => 'index'
  map.connect ':controller/:board', :action => 'index'
  map.connect ':controller/:board/new', :action => 'new'
  map.connect ':controller/:board/:id/edit', :action => 'edit'
  map.connect ':controller/:board/:id', :action => 'show'

  map.connect '*path', :controller => 'zi2/posts', :action => 'catch_all'
end
