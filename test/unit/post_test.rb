require 'test_helper'
require 'flexmock/test_unit'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  def test_should_create_with_clips
    flexmock(Clip).new_instances.should_receive(:save).once.and_return(true)
    post = Post.new(:title => 'Just Test')
    post.clips << Clip.create
    assert post.save
    #assert_equal 1, post.clips.size
  end

end
