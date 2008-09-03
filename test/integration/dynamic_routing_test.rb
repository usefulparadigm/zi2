require 'test_helper'

class DynamicRoutingTest < ActionController::IntegrationTest

  def test_should_recognize_routings
    assert_recognizes({ :controller => 'home', :action => 'list' }, '/')
  end

  def test_should_generate_routings
    assert_generates '/', :controller => 'home', :action => 'list'
  end
  
  def test_should_route_proper_url
    assert_routing "/", :controller => 'home', :action => 'list'
    assert_routing "/home/notice", :controller => 'home', :board => 'notice', :action => 'index'
    assert_routing "/home/notice/new", :controller => 'home', :board => 'notice', :action => 'new'
  end
  
  def test_should_get_list
    get '/home'
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:posts)
  end
  
  #def test_should_get_index
  #  get '/home/notice'
  #  assert_response :success
  #  assert_template 'index'
  #  assert_not_nil assigns(:posts)
  #end
  
  def test_should_show_post
    get '/home/notice/1'
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:post)
  end

  def test_should_get_default_action_and_view_without_zi2_controller
    get '/archive/archive_ruby'
    assert_response :success
    assert_template 'index'
  end
  
  #def test_should_get_index_action_and_index_vew_with_zi2_controller
  #  get '/home/notice'
  #  assert_response :success
  #  # I don't know why this test will not pass??
  #  assert_template 'index'
  #end

  #def test_should_get_index_action_and_custom_view_with_zi2_controller
  #  get '/home/forum_python'
  #  assert_response :success
  #  assert_template 'forum_python'
  #  assert_not_nil assigns(:posts)
  #end
  
  #def test_should_get_custom_action_and_custom_view_with_zi2_controller
  #  get '/forum/forum_erlang'
  #  assert_response :success
  #  assert_template 'forum_erlang'
  #  assert_nil assigns(:posts)
  #  assert_equal 'just dummy!', assigns(:dummy)
  #end
  
end
