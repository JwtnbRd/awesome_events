module SigninSupport 
  def sign_in_as(user) 
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      user.provider,
      uid: user.uid,
      info: { nickname: user.name,
              image: user.image_url}
    )

    visit root_path
    click_on "Githubでログイン"
    @current_user = user
  end

  def current_user
    @current_user
  end
end

RSpec.configure do |config|
  config.include SigninSupport 
end