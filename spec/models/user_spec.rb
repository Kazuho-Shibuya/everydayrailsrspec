# frozen_string_literal: true

require 'rails_helper'

describe User do
  # 有効なファクトリを持つこと
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 複数のユーザーで何かする
  it 'does something with multiple users' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(true).to be_truthy
  end
end

RSpec.describe User, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first name, last name, email, and password' do
    user = User.new(
      first_name: 'Aaron',
      last_name: 'Sumner',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze'
    )
    expect(user).to be_valid
  end
  # 名がなければ無効な状態であること
  it { is_expected.to validate_presence_of :first_name }

  # 姓がなければ無効な状態であること
  it { is_expected.to validate_presence_of :last_name }

  # メールアドレスがなければ無効な状態であること
  it { is_expected.to validate_presence_of :email }

  # 重複したメールアドレスなら無効な状態であること
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.name).to eq 'John Doe'
  end

  # アカウントが作成されたときにウェルカムメールを送信すること
  it 'sends a welcome email on account creation' do
    allow(UserMailer).to \
      receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  # ジオコーディングを実行すること
  it 'performs geocoding', vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: '161.185.207.20')
    expect do
      user.geocode
    end.to change(user, :location)
      .from(nil)
      .to('New York City, New York, US')
  end
end
