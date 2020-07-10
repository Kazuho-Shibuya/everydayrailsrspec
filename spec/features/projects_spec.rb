# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  # ユーザーは新しいプロジェクトを作成する
  scenario 'user creates a new project' do
    user = FactoryBot.create(:user)
    sign_in user

    visit root_path

    expect do
      click_link 'New Project'
      fill_in 'Name', with: 'Test Project'
      fill_in 'Description', with: 'Trying out Capybara'
      click_button 'Create Project'
    end.to change(user.projects, :count).by(1)

    expect(page).to have_content 'Project was successfully created'
    expect(page).to have_content 'Test Project'
    expect(page).to have_content "Owner: #{user.name}"
  end

  # ゲストがプロジェクトを追加する
  scenario 'guest adds a project' do
    user = FactoryBot.create(:user)
    sign_in user
    visit projects_path
    click_link 'New Project'
  end
end