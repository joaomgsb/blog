require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should not save post without title" do
    post = Post.new
    assert_not post.save, "Saved the post without a title"
  end

  test "should save post with title and content" do
    post = Post.new(title: "Meu primeiro post", content: "Conteúdo do post")
    post.user = users(:one)  # usando a fixture de usuário
    assert post.save, "Não salvou o post com título e conteúdo"
  end

  test "should have many comments" do
    post = posts(:one)  # usando a fixture de post
    assert_respond_to post, :comments
  end
end
