require 'rails_helper'

RSpec.describe User, type: :model do

  it { is_expected.to be_mongoid_document }

  describe 'validations' do
    subject(:user) { build(:user) }

    context 'presence fields' do
      it { is_expected.to validate_presence_of(:email) }
    end

    context 'uniqueness fields' do
      it { is_expected.to validate_uniqueness_of(:email) }
    end

    context 'exist fields of types' do
      %i[reset_password_sent_at remember_created_at
       confirmation_sent_at].each do |field|
        it { is_expected.to have_field(field).of_type(Time) }
      end
      %i[username email encrypted_password reset_password_token
       confirmation_token unconfirmed_email].each do |field|
        it { is_expected.to have_field(field).of_type(String) }
      end
    end

    context 'association' do
      it { is_expected.to have_many_related(:histories) }
      it { is_expected.to have_many_related(:comments) }
    end
  end
end
