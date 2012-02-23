# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  attribute :body
end

test "sorted set functionality" do
  @p1 = Post.create(:body => "hi")
  @p2 = Post.create(:body => "bye")
  @p3 = Post.create(:body => "x")
  @list = Ohm::Model::SortedSet.new(Ohm::Key.new('post_list'), Ohm::Model::Wrapper.wrap(Post)) {|x| x.body.length }
  @list << @p1 << @p2 << @p3
  assert_equal @list.all, [@p3,@p1,@p2]

  assert @list.include?(@p3)
  assert @list.include?(@p2)
  assert @list.include?(@p1)

  assert_equal @list.size, 3
  assert_equal @list.first, @p3

  @list.delete(@p2)
  assert_equal @list.all, [@p3,@p1]
  assert_equal @list.size, 2

  @list.add(@p2)
  assert_equal @list.all, [@p3,@p1,@p2]
  assert_equal @list.size, 3
  assert_equal @list.inspect, "#<SortedSet (Post): [\"3\", \"1\", \"2\"]>"
end

class User < Ohm::Model
  attribute :email
  sorted_set :posts , Post do |x|
     x.body.length
  end
end

test "sorted set as attribute" do
  @p1 = Post.create(:body => "hi")
  @p2 = Post.create(:body => "bye")

  @u = User.create(:email => "test@example.org")

  @u.posts << @p1
  @u.posts << @p2

  assert_equal @u.posts.all, [@p1,@p2]

  assert @u.posts.include?(@p1)
  assert @u.posts.include?(@p2)

  assert_equal @u.posts.size, 2
  assert_equal @u.posts.first, @p1

  @u2 = User.create(:email => "test@example.org")
  #@u2.posts = @u.posts

  #assert_equal @u2.posts, @u.posts

end