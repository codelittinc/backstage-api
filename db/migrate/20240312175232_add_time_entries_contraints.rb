# frozen_string_literal: true

class AddTimeEntriesContraints < ActiveRecord::Migration[7.0]
  def change
    add_index :time_entries, %i[date user_id statement_of_work_id],
              unique: true,
              name: 'index_time_entries_on_date_and_user_id_and_sow_id'
  end
end
