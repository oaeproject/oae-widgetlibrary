require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "category should have widgets" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :category_ids => [Category.first.id])
    widget.version_id = version.id
    widget.save
    category = Category.first
    assert_equal widget.id, category.widgets.first.id, "Category correctly returned a widget"
  end
end
