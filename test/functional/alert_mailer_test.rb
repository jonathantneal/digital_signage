require 'test_helper'

class AlertMailerTest < ActionMailer::TestCase
  def test_sign_down_email
    sign = signs(:one)
    sign.title = "Test"
    sign.email = "test@example.com"
    sign.last_check_in = 1.day.ago
    sign.save
 
    # Send the email, then test that it got queued
    email = AlertMailer.sign_down(sign).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    assert_equal [sign.email], email.to
    assert_equal "The Test sign may be down", email.subject
    assert_match "The Test sign may be down", email.body.to_s
    assert_match "This sign last checked in", email.body.to_s
  end

  def test_sign_down_email_frequency
    sign = signs(:one)
    sign.title = "Test"
    sign.email = "test@example.com"
    sign.email_sent = 1.minute.ago
    sign.last_check_in = 1.day.ago
    sign.save
 
    # Try to send the email, then test that it did not send
    #  It should not send because email_sent is within the past hour
    #  The following line should match the line in sign_down.rake
    if sign.email_sent && (sign.email_sent < Time.now - (AppConfig.defaults.sign.email_frequency * 3600))
      assert false, "Email should not have been sent"
    end
  end

  def test_sign_up_email
    sign = signs(:one)
    sign.title = "Test"
    sign.email = "test@example.com"
    sign.last_check_in = Time.now
    sign.save
 
    # Send the email, then test that it got queued
    email = AlertMailer.sign_up(sign).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    assert_equal [sign.email], email.to
    assert_equal "The Test sign is back up", email.subject
    assert_match "The Test sign is back up", email.body.to_s
    assert_match "This sign last checked in", email.body.to_s
  end

end
