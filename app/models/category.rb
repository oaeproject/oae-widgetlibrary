class Category < ActiveRecord::Base
  has_and_belongs_to_many :versions
  validates_presence_of :title, :url_title
  validates :title, :url_title, :uniqueness => true

  def widgets
    Widget.includes(:versions => :categories)
          .where("categories_versions.category_id = ?", self.id)
  end

end
