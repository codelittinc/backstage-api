# frozen_string_literal: true

class AddLogoBackgroundColorToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :logo_background_color, :string
  end
end
