# frozen_string_literal: true

class RemoveIndexUsersOnGoogleId < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, column: :google_id, name: :index_users_on_google_id
  end
end
