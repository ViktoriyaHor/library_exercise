require 'rails_helper'

RSpec.describe History, type: :model do

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps.for(:creating) }

  describe 'validations' do
    subject(:history) { build(:history) }

    context 'presence' do
      it { is_expected.to validate_presence_of(:return_at) }
    end

    context 'exist fields of types' do
      %i[created_at return_at].each do |field|
        it { is_expected.to have_field(field).of_type(Time) }
      end
    end

    context 'association' do
      it { is_expected.to belong_to(:user) }
      it { is_expected.to belong_to(:book) }
    end
  end

  describe 'methods' do
    let!(:book_with_histories) { create(:book_with_histories) }
    let(:book) { create(:book) }
    let(:user) { create(:user) }
    let!(:history) { create(:history, book: book, user: user) }

    context 'self.find_by_book(id)' do
      it "retuns data with a valid parameter" do
        expect(History.find_by_book(book.id).to_a).to eq([history])
      end

      it "retuns nil with a parameter nil" do
        expect(History.find_by_book(nil).to_a).to eq []
      end
    end

    context 'self.find_by_user(id)' do
      it "retuns data with a valid parameter" do
        expect(History.find_by_user(user.id).to_a).to eq([history])
      end

      it "retuns nil with a parameter nil" do
        expect(History.find_by_user(nil).to_a).to eq []
      end
    end
  end

  describe 'default_scope' do

    let!(:history1) { create(:history, created_at: DateTime.now) }
    let!(:history2) { create(:history, created_at: DateTime.now + 1) }

    it "retuns order by created_at: :desc" do
      expect(History.all.to_a).to eq([history2, history1])
    end
  end
end
