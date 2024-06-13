# frozen_string_literal: true

class RenameProjectAuthToProjectReport < ActiveRecord::Migration[7.0]
  def change
    rename_table :project_auths, :project_reports
  end
end
