require 'spec_helper'

describe AlertMailer do
  let(:last_check_in) { nil }
  let(:email_sent) { nil }
  let(:sign) { create :sign, :with_email, last_check_in: last_check_in, email_sent: email_sent }

  describe 'sign down email' do
    context 'last check_in was 2 days ago' do
      let(:last_check_in) { 2.days.ago }

      context 'never sent before' do
        it 'gets sent' do
          # Send the email, then test that it got queued
          email = nil
          expect {
            email = AlertMailer.sign_down(sign).deliver
          }.to change{
            ActionMailer::Base.deliveries.count
          }.by 1

          # Test the body of the sent email contains what we expect it to
          expect(email.to).to eql [sign.email]
          expect(email.subject).to eql "The #{sign.title} sign may be down"
          expect(email.body).to match "The #{sign.title} sign may be down"
          expect(email.body).to match "This sign last checked in"
        end
      end

      context 'email sent 1 minute ago' do
        let(:email_sent) { 1.minute.ago }

        # Apparently the check for this is baked into the cron job
        it 'gets sent again' do
          expect {
            AlertMailer.sign_down(sign).deliver
          }.to change{
            ActionMailer::Base.deliveries.count
          }.by 1
        end
      end
    end
  end

  describe 'sign up email' do
    context(:just_checked_in) do
      let(:last_check_in) { Time.now }

      it 'gets sent' do
        email = nil
        expect {
          email = AlertMailer.sign_up(sign).deliver
        }.to change{
          ActionMailer::Base.deliveries.count
        }.by 1

        # Test the body of the sent email contains what we expect it to
        expect(email.to).to eql [sign.email]
        expect(email.subject).to eql "The #{sign.title} sign is back up"
        expect(email.body).to match "The #{sign.title} sign is back up"
        expect(email.body).to match "This sign last checked in"
      end
    end
  end
end