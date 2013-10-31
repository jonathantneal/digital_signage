require 'spec_helper'

describe Sign do
  it { should belong_to :department }
  it { should have_many(:slots).dependent(:destroy) }
  it { should have_many(:slides) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :name }
  it { should validate_presence_of :department_id }
  it { should validate_presence_of :reload_interval }
  it { should validate_presence_of :check_in_interval }


  describe :checked_in? do
    it 'is checked in' do
      expect(create(:sign, last_check_in: nil).checked_in?).to eql false
    end
    it 'has not checked in' do
      expect(create(:sign, last_check_in: 1.hour.ago).checked_in?).to eql true
    end
  end

  describe :send_down_alert? do
    let(:last_check_in) { nil }
    let(:email) { nil }
    let(:sign) { create :sign, last_check_in: last_check_in, email: email }
    subject { sign.send_down_alert? }

    context 'with email' do
      let(:email) { 'test@example.com' }
      context 'never checked in' do
        it { should be_false }
      end
      context 'checked in 1 minute ago' do
        let(:last_check_in) { 1.minute.ago }
        it { should be_false }
      end
      context 'checked in 2 days ago' do
        let(:last_check_in) { 2.days.ago }
        it { should be_true }
      end
    end

    context 'without email' do
      context 'checked in 2 days ago' do
        let(:last_check_in) { 2.days.ago }
        it { should be_false }
      end
    end
  end
end