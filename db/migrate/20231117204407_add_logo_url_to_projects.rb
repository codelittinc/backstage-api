# frozen_string_literal: true

class AddLogoUrlToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :logo_url, :string
  end
end
