# frozen_string_literal: true

require 'rails_helper'
require 'mongo'

#Mongo::Logger.logger.level = ::Logger::DEBUG

RSpec.describe Author, type: :model do

  it { is_expected.to be_mongoid_document }

  describe 'validations' do
    subject(:author) { build(:author) }

    context 'presence' do
      it { is_expected.to validate_presence_of :fullname }
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of :fullname }
    end

    context 'exist fields of types' do
      %i[fullname].each do |field|
          it { is_expected.to have_field(field).of_type String }
        end
    end

    context 'association' do
      it { is_expected.to embed_many :books }
    end
  end

  describe 'method self.find_by_fullname(fullname)' do
    3.times do |i|
      i += 1
      let!(:"author_#{i}") { create(:author, fullname: "Author#{i}") }
    end

    it "retuns data with a valid parameter" do
      expect(Author.find_by_fullname('Author1')).to eq author_1
    end

    it "retuns nil with a parameter nil" do
      expect(Author.find_by_fullname(nil)).to eq nil
    end
  end
end
