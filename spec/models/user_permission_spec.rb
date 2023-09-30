require 'rails_helper'

RSpec.describe UserPermission, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:target) }
    it { should validate_presence_of(:ability) }
  end
end
