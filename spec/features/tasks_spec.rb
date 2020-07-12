# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) do
    FactoryBot.create(:project,
                      name: 'RSpec tutorial',
                      owner: user)
  end
  let!(:task) { project.tasks.create!(name: 'Finish RSpec tutorial') }

  # ユーザーがタスクの状態を切り替える
  scenario 'user toggles a task', js: true, vcr: true do
    sign_in user
    go_to_project 'RSpec tutorial'
    complete_task 'Finish RSpec tutorial'
    expect_complete_task 'Finish RSpec tutorial'
    undo_complete_task 'Finish RSpec tutorial'
    expect_incomplete_task 'Finish RSpec tutorial'
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css 'label.completed', text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css 'label.completed', text: name
      expect(task.reload).to_not be_completed
    end
  end
end
