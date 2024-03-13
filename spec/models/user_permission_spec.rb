# frozen_string_literal: true

# == Schema Information
#
# Table name: user_permissions
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  permission_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_user_permissions_on_permission_id              (permission_id)
#  index_user_permissions_on_user_id                    (user_id)
#  index_user_permissions_on_user_id_and_permission_id  (user_id,permission_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (permission_id => permissions.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserPermission, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:permission) }

    it 'validates uniqueness of user_id scoped to permission_id' do
      permission = create(:permission)
      user1 = create(:user)

      user_permission1 = create(:user_permission, user: user1, permission:)
      expect(user_permission1).to be_valid
      user_permission2 = build(:user_permission, user: user1, permission:)
      user_permission2.save
      expect(user_permission2).to be_invalid
    end
  end
end
