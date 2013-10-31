module AuthenticationHelpers
  def set_current_user(user)
    session['cas'] = { 'user' => user.try(:username), 'extra_attributes' => {} }
  end

  # for integration tests
  def login_as(user)
    visit root_path(login: true)
    fill_in 'username', with: user.try(:username)
    fill_in 'password', with: 'bogus password'
    click_button 'Login'
  end
end