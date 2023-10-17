# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clients::Tts::Azure::Client, type: :service do
  let(:customer) { FactoryBot.create(:customer, name: 'Ministry Brands') }

  let(:project) do
    FactoryBot.create(:project, customer:,
                                metadata: { azure_project_name: '1ES', area_path: '1ES\\DDC UI Refresh\\2023' })
  end

  it 'defines the correct customer URL' do
    url = Clients::Tts::Azure::Client.new(project).customer_url
    expect(url).to eq('https://dev.azure.com/ministrybrands')
  end
end
