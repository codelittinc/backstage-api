# frozen_string_literal: true

json.array! @time_entries, partial: 'time_entries/time_entry', as: :time_entry
