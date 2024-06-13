# frozen_string_literal: true

class AddUniqueIndexToTimeOffs < ActiveRecord::Migration[7.0]
  def change
    add_index :time_offs, %i[starts_at ends_at time_off_type_id user_id], unique: true,
                                                                          name: 'index_time_offs_on_unique_combination'
  end
end
