require 'test_helper'

class ClipsControllerTest < ActionController::TestCase
  tests Zi2::ClipsController

  def test_should_delete_clip
    delete :destroy, :post_id => 3, :id => 1
    assert_response :success
    assert_not_nil assigns(:clip)
  end
end
