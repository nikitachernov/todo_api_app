require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    subject { task }

    let(:task) { build(:task, title: title) }
    let(:title) { "Wash laundry" }

    it { should be_valid }

    context "when without title" do
      let(:title) { "" }

      it { should be_invalid }
    end
  end
end
