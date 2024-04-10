# frozen_string_literal: true

json.array! @dynamic_datasets, partial: 'dynamic_datasets/dynamic_dataset', as: :dynamic_dataset
