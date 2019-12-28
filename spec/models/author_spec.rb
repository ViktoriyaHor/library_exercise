require 'rails_helper'
require 'mongo'

Mongo::Logger.logger.level = ::Logger::DEBUG

RSpec.describe Author, type: :model do
  describe 'validations' do
    subject(:author) { build(:author) }

    context 'presence' do
      %i[fullname].each do |field|
        it { is_expected.to validate_presence_of(field) }
      end
    end
    #
    #context 'exist columns of types' do
    #  %i[fullname].each do |field|
    #      it { is_expected.to have_db_column(field).of_type(:string) }
    #    end
    #end
  end
end
