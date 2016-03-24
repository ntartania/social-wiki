require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
    session[:user_id] = users(:user1).id
  end

  test "should upvote post" do
    put :upvote, id: @post
    assert users(:user1).voted_up_on? @post 
  end  

  test "should downvote post" do
    put :downvote, id: @post
    assert users(:user1).voted_down_on? @post 
  end  
  
  test "should cancel upvote" do
    put :upvote, id: @post
    put :upvote, id: @post
    refute users(:user1).voted_up_on? @post 
  end

  test "should cancel downvote" do
    put :downvote, id: @post
    put :downvote, id: @post
    refute users(:user1).voted_down_on? @post 
  end 

  test "should have score of 2  after getting 2 upvotes with seperate users" do
    put :upvote, id: @post
    session[:user_id] = users(:user2).id
    put :upvote, id: @post
    assert @post.score == 2
  end  
  test "should have score of -2 after getting 2 downvotes with seperate users" do
    put :downvote, id: @post
    session[:user_id] = users(:user2).id
    put :downvote, id: @post
    assert @post.score == -2
  end  
  test "should have score of 0 after getting 1 upvote and 1 downvote with seperate users" do
    put :upvote, id: @post
    session[:user_id] = users(:user2).id
    put :downvote, id: @post
    assert @post.score == 0
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: {contents: @post.contents, title: @post.title }
    end
    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    patch :update, id: @post, post: {contents: @post.contents, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

 test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end
    assert_redirected_to posts_path
  end
  test "should not destroy post" do
    session[:user_id] = users(:user2).id
    assert_difference('Post.count', 0) do
      delete :destroy, id: @post
    end
    assert_redirected_to posts_path
     
  end
end
