require 'test_helper'
#require 'flexmock/test_unit'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  #def test_should_create_with_clips
  #  flexmock(Clip).new_instances.should_receive(:save).once.and_return(true)
  #  post = Post.new(:title => 'Just Test')
  #  post.clips << Clip.create
  #  assert post.save
  #  #assert_equal 1, post.clips.size
  #end

  def test_should_filter_open_level_private
    current_user = users('tester')
    private_post = current_user.posts.create(:title => 't', :content => 't', :open_level => OpenLevel::PRIVATE)
    assert Post.filter(current_user).include?(private_post)
  end
  
  def test_should_filter_open_level_friends_only
    current_user = users(:tester)
    someone = users(:someone)
    current_user.become_friends_with someone
    friends_only_post = current_user.posts.create(:title => 't', :content => 't', :open_level => OpenLevel::FRIENDS_ONLY)
    assert Post.filter(someone).include?(friends_only_post)
  end
  
  def test_should_filter_open_level_members_only
    current_user = users(:tester)
    members_only_post = current_user.posts.create(:title => 't', :content => 't', :open_level => OpenLevel::MEMBERS_ONLY)
    assert !Post.filter(nil).include?(members_only_post)
  end

end
