require 'rails_helper'


RSpec.describe User, type: :model do

  let(:user) {User.new()}

  let(:event1) {Event.new()}
  let(:event2) {Event.new()}

  describe 'past_events' do
    it 'returns events user has attended with start dates before RIGHT NOW' do
    expect(user.past_events.length).to eq(1)
    end
  end



end
