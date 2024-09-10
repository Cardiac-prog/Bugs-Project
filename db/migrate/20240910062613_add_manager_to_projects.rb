class AddManagerToProjects < ActiveRecord::Migration[7.2]
  def change
    add_reference :projects, :manager, null: false, foreign_key: { to_table: :users }
  end
end
