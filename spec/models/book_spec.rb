require 'rails_helper'

RSpec.describe Book, type: :model do

  it { is_expected.to be_mongoid_document }

  describe 'validations' do
    subject(:book) { build(:book) }

    context 'presence fields' do
      %i[name description].each do |field|
        it { is_expected.to validate_presence_of(field) }
      end
    end

    context 'uniqueness fields' do
      %i[name description].each do |field|
        it { is_expected.to validate_uniqueness_of(field) }
      end
    end

    context 'exist fields of types' do
      %i[name description].each do |field|
        it { is_expected.to have_field(field).of_type(String) }
      end
      it { is_expected.to have_field(:status).of_type(Mongoid::Boolean).with_default_value_of(false) }
      it { is_expected.to have_field(:image).of_type(Object) }
    end

    context 'association' do
      it { is_expected.to have_many_related(:histories) }
      it { is_expected.to have_many_related(:comments) }
      it { is_expected.to be_embedded_in(:author) }
    end
  end
end
