require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User should have many campaigns" do
    it { should have_many(:campaigns) }
  end
end
