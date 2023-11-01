require 'rails_helper'

RSpec.describe "DeleteEvents", type: :system do

  let(:user) { FactoryBot.create(:user) }
  let(:other_event) { FactoryBot.create(:event) }

  describe "testing work-flow for deleting events" do 
    scenario "when user tries to delete own event", js: true do 
      sign_in_as user
      event = FactoryBot.create(:event, owner: current_user)
      visit event_path(event)
      expect(page).to have_selector "a.btn-danger", text: "イベントを削除する"

      expect {
        click_on "イベントを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_selector ".alert-success", text: "削除しました"
      }.to change(user.created_events, :count).by(-1)
    end

    scenario "when user access other user's event page" do 
      sign_in_as user
      visit event_path(other_event)
      expect(page).to_not have_selector "a.btn-danger", text: "イベントを削除する"
    end
  end
end
