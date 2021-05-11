require 'rails_helper'

RSpec.describe User, type: :model do
  # before { @user = FactoryGirl.build(:user) } não é nescessáio pois o bloco cria uma variáveil "invisivel" referente ao "User" 
  let(:user) { build(:user) }

  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  # Teste se a função de validar foi implementada
  # it { expect(user).to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }

  # >>> são as mesmas coisas <<<
  # it { expect(@user).to respond_to(:email) }
  # it { expect(subject).to respond_to(:email) }
  # it { is_expected.to respond_to(:email) }

  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'Return email, created_at adn Token' do
      user.save!
      
      #Serve como duble 
      allow(Devise).to receive(:friendly_token).and_return('abc1234abc')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - abc1234abc")
    end
  end

  describe '#generate_authetication_token' do
    it 'generate a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('123456789')
      
      user.generate_authentication_token!

      expect(user.auth_token).to eq('123456789')
    end

    it 'generates another auth token when the current auth token already has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('123456789', '123456789', 'abcdefghi')
      new_user = create(:user)
      
      expect(new_user.auth_token).not_to eq(user.auth_token)
    end
  end
end
