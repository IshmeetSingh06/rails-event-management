require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:admin) { FactoryBot.create(:user, role: "admin") }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:organizer_id) }
  it { is_expected.to validate_presence_of(:time).with_message("Invalid") }
  it { is_expected.to validate_numericality_of(:capacity).is_greater_than(0) }
  it { is_expected.to belong_to(:organizer).class_name('User').with_foreign_key('organizer_id') }
  it { is_expected.to have_many(:registrations) }
  it { is_expected.to have_many(:attendees).through(:registrations).source(:user) }

  describe '.scope' do
    it 'has an active scope' do
      active_event = FactoryBot.create(:event, organizer: admin)
      inactive_event = FactoryBot.create(:event, cancelled: true, organizer: admin)
      expect(Event.active).to include(active_event)
      expect(Event.active).not_to include(inactive_event)
    end

    it 'has an upcoming scope' do
      event = FactoryBot.create(:event, organizer: admin)
      expect(Event.upcoming).to include(event)
    end
  end

  describe '#cancelled' do
    it 'validates that an already cancelled event cannot be updated' do
      event = FactoryBot.create(:event, cancelled: true, organizer: admin)
      event.update(name: 'New Name')
      expect(event.errors.full_messages).to include('Event is already cancelled')
    end
  end
end
