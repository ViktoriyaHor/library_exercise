# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps.for :creating }

  describe 'validations' do
    subject(:comment) { build(:comment) }

    context 'presence fields' do
      %i[body rating].each do |field|
        it { is_expected.to validate_presence_of field }
      end
    end

    context 'exist fields of types' do
      it { is_expected.to have_field(:body).of_type String }
      it { is_expected.to validate_numericality_of(:rating).less_than_or_equal_to 5}
      it { expect(subject.rating).to eq 0 }
    end

    context 'association' do
      it { is_expected.to belong_to :user }
      it { is_expected.to belong_to :book }
    end
  end
  describe 'method self.find_by_book(id)' do
    let!(:book_with_comments) { create(:book_with_comments) }
    let(:book) { create(:book) }
    let!(:comment) { create(:comment, book: book) }

    context 'self.find_by_book(id)' do
      it "retuns data with a valid parameter" do
        expect(Comment.find_by_book(book.id).to_a).to eq [comment]
      end

      it "retuns nil with a parameter nil" do
        expect(Comment.find_by_book(nil).to_a).to eq []
      end
    end
  end

  describe 'default_scope' do

    let!(:comment1) { create(:comment, created_at: DateTime.now) }
    let!(:comment2) { create(:comment, created_at: DateTime.now + 1) }

    it "retuns order by created_at: :desc" do
      expect(Comment.all.to_a).to eq [comment2, comment1]
    end
  end
end
