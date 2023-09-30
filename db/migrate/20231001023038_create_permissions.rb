class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :target, null: false
      t.string :ability, null: false

      t.timestamps
    end
  end
end
