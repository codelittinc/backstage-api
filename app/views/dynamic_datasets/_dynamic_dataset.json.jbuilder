# frozen_string_literal: true

json.extract! dynamic_dataset, :id, :name, :project_id

json.data dynamic_dataset.execute
