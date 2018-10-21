require "rails_helper"

RSpec.describe TasksWithTagsQuery do
  describe "#call" do
    before { create_list(:task, 3, tags_count: 5) }

    let(:tasks) { TasksWithTagsQuery.call }

    it "returns tasks" do
      expect(tasks.count).to eq(3)
    end
  end
end
