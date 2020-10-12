require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
  end

  describe "ログインページ" do
    context "ログイン処理" do
      it "無効なユーザーでログインを行うとログインが失敗することを確認" do
        fill_in "user_email", with: "user@example.com"
        fill_in "user_password", with: "pass"
        click_button "ログイン"
        expect(page).to have_content 'メールアドレスとパスワードの組み合わせが誤っています'

        visit root_path
        expect(page).not_to have_content "メールアドレスとパスワードの組み合わせが誤っています"
      end

      it "有効なユーザーでログインする前後でヘッダーが正しく表示されていることを確認" do
        expect(page).to have_link 'クックログとは？', href: about_path
        expect(page).to have_link 'ユーザー登録(無料)', href: signup_path
        expect(page).to have_link 'ログイン', href: login_path
        expect(page).not_to have_link 'ログアウト', href: logout_path

        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "ログイン"

        expect(page).to have_link 'クックログとは？', href: about_path
        expect(page).to have_link 'ユーザー一覧', href: users_path
        expect(page).to have_link 'プロフィール', href: user_path(user)
        expect(page).to have_link 'ログアウト', href: logout_path
        expect(page).not_to have_link 'ログイン', href: login_path
      end
    end
  end
end