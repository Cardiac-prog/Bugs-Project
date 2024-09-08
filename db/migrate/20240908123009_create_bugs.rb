class CreateBugs < ActiveRecord::Migration[7.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :description
      t.integer :category
      t.integer :priority
      t.references :reported_by, null: false, foreign_key: { to_table: :users }
      t.references :assigned_to, null: false, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
