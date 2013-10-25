class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :human, polymorphic: true
      t.references :role, null: false
      t.string :source
    end

    add_index :assignments, :human_id
    add_index :assignments, :role_id
    add_index :assignments, :source
    add_index :assignments, [:human_id, :role_id]
  end
end