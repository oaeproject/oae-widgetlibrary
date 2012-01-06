class Category < ActiveRecord::Base
  has_and_belongs_to_many :versions

  def widgets
    Widget.includes(:versions => :categories).where("categories_versions.category_id = ?", self.id)
  end

end
