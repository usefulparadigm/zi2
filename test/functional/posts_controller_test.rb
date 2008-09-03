require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  tests Zi2::PostsController
#  fixtures :groups, :boards, :posts
  
  def test_should_edit_with_clips
    login_as 'admin'
    get :edit, :board => 'ruby', :id => 3  
    assert_response :success
    assert_not_nil assigns(:post)
  end
  
  def test_should_upload_a_clip
    login_as 'tester'
    image_file = File.join(RAILS_ROOT, 'public', 'images', 'rails.png')
    post :upload, :format => :js, :clip => {
      :temp_path => image_file,
      :content_type => 'image/png',
      :filename => 'rails.png'
    }
    #assert_not_nil assigns(:clip)
  end

  def test_should_not_show_filtered_post
    login_as 'tester'
    post = posts(:friends_only)
    get :show, :id => 4, :board => post.board.name
    assert_response :redirect
  end
end
