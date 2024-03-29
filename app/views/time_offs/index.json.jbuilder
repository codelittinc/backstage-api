# frozen_string_literal: true

json.array! @time_offs, partial: 'time_offs/time_off', as: :time_off
