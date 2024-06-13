# frozen_string_literal: true

# == Schema Information
#
# Table name: time_offs
#
#  id               :bigint           not null, primary key
#  ends_at          :datetime
#  starts_at        :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  time_off_type_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_time_offs_on_time_off_type_id    (time_off_type_id)
#  index_time_offs_on_unique_combination  (starts_at,ends_at,time_off_type_id,user_id) UNIQUE
#  index_time_offs_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (time_off_type_id => time_off_types.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :time_off do
    user
    time_off_type
    starts_at { '2023-11-06 17:32:01' }
    ends_at { '2023-12-06 17:32:01' }

    trait :vacation do
      time_off_type { TimeOffType.create(name: TimeOffType::VACATION_TYPE) }
    end

    trait :sick_leave do
      time_off_type { TimeOffType.create(name: TimeOffType::SICK_LEAVE_TYPE) }
    end
  end
end
