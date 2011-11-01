# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  attribute :body
end

test "sorted set functionality" do
  @p1 = Post.create(:body => "hi")
  @p2 = Post.create(:body => "bye")
  @list = Ohm::Model::SortedSet.new(Ohm::Key.new('post_list'),Ohm::Model::Wrapper.wrap(Post))
  @list << @p1
  @list << @p2
  assert_equal @list.all, [@p1,@p2]
  assert_equal @list.size, 2
  assert_equal @list.first, @p1

  @list.delete(@p2)
  assert_equal @list.all, [@p1]
  assert_equal @list.size, 1

  @list.add(@p2)
  assert_equal @list.all, [@p1,@p2]
  assert_equal @list.size, 2
  assert_equal @list.inspect, "#<SortedSet (Post): [\"1\", \"2\"]>"
end

class User < Ohm::Model
  attribute :email
  sorted_set :posts, Post
end

test "sorted set as attribute" do
  @p1 = Post.create(:body => "hi")
  @p2 = Post.create(:body => "bye")

  @u = User.create(:email => "test@example.org")
  
  @u.posts << @p1
  @u.posts << @p2
  
  assert_equal @u.posts.all, [@p1,@p2]
  assert_equal @u.posts.size, 2
  assert_equal @u.posts.first, @p1
  
end