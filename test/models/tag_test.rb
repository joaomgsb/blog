require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "should not save tag without name" do
    tag = Tag.new
    assert_not tag.save, "Salvou a tag sem um nome"
  end

  test "should not save tag with duplicate name" do
    existing_tag = tags(:ruby)
    tag = Tag.new(name: existing_tag.name)
    assert_not tag.save, "Salvou a tag com nome duplicado"
  end

  test "should save valid tag" do
    tag = Tag.new(name: "Nova Tag")
    assert tag.save, "Não salvou uma tag válida"
  end

  test "should have many posts through post_tags" do
    tag = tags(:ruby)
    assert_respond_to tag, :posts
  end
end
