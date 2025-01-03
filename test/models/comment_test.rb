require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should not save comment without content" do
    comment = Comment.new(user: users(:one), post: posts(:one))
    assert_not comment.save, "Salvou o comentário sem conteúdo"
  end

  test "should not save comment without user" do
    comment = Comment.new(content: "Test comment", post: posts(:one))
    assert_not comment.save, "Salvou o comentário sem usuário"
  end

  test "should not save comment without post" do
    comment = Comment.new(content: "Test comment", user: users(:one))
    assert_not comment.save, "Salvou o comentário sem post"
  end

  test "should save valid comment" do
    comment = Comment.new(
      content: "Um comentário válido",
      user: users(:one),
      post: posts(:one)
    )
    assert comment.save, "Não salvou um comentário válido"
  end

  test "should belong to user" do
    comment = comments(:comment_one)
    assert_respond_to comment, :user
    assert_instance_of User, comment.user
  end

  test "should belong to post" do
    comment = comments(:comment_one)
    assert_respond_to comment, :post
    assert_instance_of Post, comment.post
  end
end
