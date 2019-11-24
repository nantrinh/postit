class AddSlugs < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slug, :string
    add_column :posts, :slug, :string
    add_column :categories, :slug, :string
  end
end
