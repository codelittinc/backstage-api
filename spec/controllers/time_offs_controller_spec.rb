# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeOffsController, type: :controller do
  render_views

  let!(:user) { create(:user, first_name: 'Kaio', last_name: 'Magalhaes') }

  def valid_params(text, _start_datetime = '2018-03-29T13:34:00', end_datetime = '2018-03-29T17:35:00')
    { webhook_time_off: {
      text:,
      start_datetime: end_datetime, end_datetime:
    } }
  end

  before do
    user
  end

  describe '#create' do
    context 'with valid params' do
      it 'creates a new TimeOff' do
        post :create, params: valid_params('Kaio Costa Porto De Magalhães on Paid Time Off')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a Paid Time Off request it' do
      it "creates a time off with the 'paid time off' type" do
        post :create, params: valid_params('Kaio Costa Porto De Magalhães on Paid Time Off')
        time_of_id = response.parsed_body['id']
        time_off = TimeOff.find(time_of_id)

        expect(time_off.time_off_type.name).to eq('vacation')
      end
    end

    context 'with an On Errands request it' do
      it "creates a time off with the 'errands' type" do
        post :create, params: valid_params('Kaio Costa Porto De Magalhães on Errands')
        time_of_id = response.parsed_body['id']
        time_off = TimeOff.find(time_of_id)

        expect(time_off.time_off_type.name).to eq('errand')
      end
    end

    context 'with a Sick Leave request it' do
      it "creates a time off with the 'sick leave' type" do
        post :create, params: valid_params('Kaio Costa Porto De Magalhães on Sick Leave')
        time_of_id = response.parsed_body['id']
        time_off = TimeOff.find(time_of_id)

        expect(time_off.time_off_type.name).to eq('sick leave')
      end
    end

    context 'with a start and end date difference of less than 4 hours' do
      it 'creates a time off request' do
        start_date = '2018-03-29T13:34:00'
        end_date = '2018-03-29T14:35:00'
        difference_in_hours = (Time.zone.parse(end_date) - Time.zone.parse(start_date)) / 3600

        # confirm the difference in hours between the dates
        expect(difference_in_hours).to be < 4

        post :create,
             params: valid_params('Kaio Costa Porto De Magalhães on Errands', end_date,
                                  end_date)

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#destroy' do
    context 'with valid params' do
      it 'finds and deletes the time off' do
        create(:time_off_type)
        # first creat the time off
        post :create,
             params: valid_params('Kaio Costa Porto De Magalhães on Paid Time Off')

        expect do
          delete :destroy, params: valid_params('Kaio Costa Porto De Magalhães on Paid Time Off')
        end.to change(TimeOff, :count).by(-1)
      end
    end
  end
end
