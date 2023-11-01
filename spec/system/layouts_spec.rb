require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe "testing layouts in home page" do 
    scenario "when non-logged-in user accesses root_path and tries to create new event" do 
      5.times do 
        FactoryBot.create(:event)
      end
      visit root_path
      expect(page).to have_selector "h1", text: "イベント一覧"
      expect(page).to have_selector "h5", text: Event.first.name
      expect(page.all("h5.list-group-item-heading").count).to eq 5 
      
      click_on 'イベントを作る'
      expect(page).to have_selector ".alert-danger", text: "ログインしてください"
    end

    scenario "when user logges in with omniauth and tries to create new event" do
      sign_in_as user
      expect(page).to have_selector ".alert-success", text: "ログインしました"
      
      click_on 'イベントを作る'
      expect(page).to have_selector "h1", text: "イベント作成"
    end

    scenario "when logged in user tries to logges out" do 
      sign_in_as user

      click_on "ログアウト"
      expect(page).to have_selector ".alert-success", text: "ログアウトしました"
    end

    scenario "when logged in user tries to delete own account" do 
      sign_in_as user

      click_on "退会"
      expect(page).to have_selector "h1", text: "退会の確認"
      expect(page).to have_selector "button.btn-danger", text: "退会する"
    end

    scenario "past event shouldn't appear in home page, only future events appear" do 
      future_event = FactoryBot.create(:event, start_at: Time.zone.now + 3.day)
      past_event = FactoryBot.create(:event, start_at: Time.zone.now + 1.day)

      travel_to Time.zone.now + 2.day do 
        visit root_path
        expect(page).to have_selector "h5", text: future_event.name
        expect(page).to_not have_selector "h5", text: past_event.name
      end
    end
  end
end
