require "rails_helper"

RSpec.describe TagsQuery do
  describe "#call" do
    before { create_list(:tag, 3) }

    let(:tags) { TagsQuery.call }

    it "returns tags" do
      expect(tags.count).to eq(3)
    end
  end
end
