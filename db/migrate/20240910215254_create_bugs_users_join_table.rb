  class CreateBugsUsersJoinTable < ActiveRecord::Migration[7.2]
    def change
      create_table :bugs_users, id: false do |t|
        t.integer :bug_id, null: false
        t.integer :user_id, null: false

        t.index [ :bug_id, :user_id ], unique: true, name: 'index_bugs_users_on_bug_id_and_user_id'
        t.index [ :user_id, :bug_id ], name: 'index_bugs_users_on_user_id_and_bug_id'
      end
    end
  end
