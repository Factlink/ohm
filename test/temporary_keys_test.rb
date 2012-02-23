# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  attribute :body
  list :related, Post
end

class User < Ohm::Model
  attribute :email
  set :posts, Post
end

test "key should be volatile" do
  @user = User.create
  @user.posts.add Post.create(:body => "D") # add Post to actually create the key
  @user.posts.send("temporary", @user.posts)

  assert @user.posts.key.ttl != -1
  assert @user.posts.key.ttl <= 300
end