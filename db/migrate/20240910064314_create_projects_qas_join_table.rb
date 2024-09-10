class CreateProjectsQasJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_table :projects_qas, id: false do |t|     # Correctly not using an ID, as it's a pure join table
      t.integer :project_id, null: false             # Project ID, can't be null
      t.integer :user_id, null: false                # User ID (for QA), can't be null
    end

    # Indexes for individual columns
    add_index :projects_qas, :project_id
    add_index :projects_qas, :user_id

    # Composite index to ensure unique project and user (QA) combinations
    add_index :projects_qas, [ :project_id, :user_id ], unique: true             # a single qa can't be added on the same project multiple times

    # Foreign key constraints for referential integrity
    add_foreign_key :projects_qas, :projects                         # References the 'projects' table
    add_foreign_key :projects_qas, :users, column: :user_id          # References the 'users' table (QA is a User)
  end
end
