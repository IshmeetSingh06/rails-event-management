require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to have_many(:registrations) }
  it { is_expected.to have_many(:organized_events).
    class_name('Event').with_foreign_key('organizer_id')
  }
  it { is_expected.to define_enum_for(:role) }
  it { is_expected.to allow_value('hello@hi.com').for(:email) }
  it { is_expected.to have_many(:attended_events).through(:registrations).source(:event) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it 'generates an authentication token before create' do
    expect(FactoryBot.create(:user).authentication_token).not_to be_nil
  end

  describe '.scope' do
    it 'has an active scope' do
      active_user = FactoryBot.create(:user)
      inactive_user = FactoryBot.create(:user, active: false)
      expect(User.active).to include(active_user)
      expect(User.active).not_to include(inactive_user)
    end
  end
end
