# frozen_string_literal: true

json.array! @requirements, partial: 'requirements/requirement', as: :requirement
