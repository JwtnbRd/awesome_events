require 'rails_helper'

RSpec.describe "CreateEvents", type: :system do

  let(:user) { FactoryBot.create(:user) }

  describe "testing work-flow for cratting event" do
    scenario "when logged in user tries to create a new event" do 
      sign_in_as user

      click_on "イベントを作る"
  
      expect{
        fill_in "名前", with: "TokyuRubyKaigi"
        fill_in "場所", with: "東京"
        fill_in "内容", with: "tokyu.rbによる地域Ruby会議"
        
        start_at = Time.current
        end_at = start_at + 3.hour
        
        start_at_field = "event_start_at"
        select start_at.strftime("%Y"), from: "#{start_at_field}_1i" # 年
        select I18n.l(start_at, format: '%B'), from: "#{start_at_field}_2i" # 月
        select start_at.strftime("%-d"), from: "#{start_at_field}_3i" # 日
        select start_at.strftime("%H"), from: "#{start_at_field}_4i" # 時
        select start_at.strftime("%M"), from: "#{start_at_field}_5i" # 分
        
        end_at_field = "event_end_at"
        select end_at.strftime("%Y"), from: "#{end_at_field}_1i" # 年
        select I18n.l(end_at, format: '%B'), from: "#{end_at_field}_2i" # 月
        select end_at.strftime("%-d"), from: "#{end_at_field}_3i" # 日
        select end_at.strftime("%H"), from: "#{end_at_field}_4i" # 時
        select end_at.strftime("%M"), from: "#{end_at_field}_5i" # 分
        click_on "登録する"
        expect(page).to have_selector ".alert-success", text: "作成しました"
      }.to change(user.created_events, :count).by(1)
    end

    scenario "when user submits invalid params", js: true do 
      sign_in_as user

      click_on "イベントを作る"
    
      expect{
        fill_in "名前", with: ""
        fill_in "場所", with: "東京"
        fill_in "内容", with: "tokyu.rbによる地域Ruby会議"
          
        start_at = Time.current
        end_at = start_at + 3.hour
          
        start_at_field = "event_start_at"
        select start_at.strftime("%Y"), from: "#{start_at_field}_1i" # 年
        select I18n.l(start_at, format: '%B'), from: "#{start_at_field}_2i" # 月
        select start_at.strftime("%-d"), from: "#{start_at_field}_3i" # 日
        select start_at.strftime("%H"), from: "#{start_at_field}_4i" # 時
        select start_at.strftime("%M"), from: "#{start_at_field}_5i" # 分
          
        end_at_field = "event_end_at"
        select end_at.strftime("%Y"), from: "#{end_at_field}_1i" # 年
        select I18n.l(end_at, format: '%B'), from: "#{end_at_field}_2i" # 月
        select end_at.strftime("%-d"), from: "#{end_at_field}_3i" # 日
        select end_at.strftime("%H"), from: "#{end_at_field}_4i" # 時
        select end_at.strftime("%M"), from: "#{end_at_field}_5i" # 分
        click_on "登録する"
        expect(page).to have_selector "li"
      }.to_not change(user.created_events, :count)
    end

    scenario "when non logged in user tries to create a new event" do
      visit root_path
      click_on "イベントを作る"
      expect(page).to have_selector ".alert-danger", text: "ログインしてください"
    end
  end 
end
