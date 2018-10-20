require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "validations" do
    subject { tag }

    let(:tag) { build(:tag, title: title) }
    let(:title) { "Today" }

    it { should be_valid }

    context "when without title" do
      let(:title) { "" }

      it { should be_invalid }
    end

    context "when without not unique title" do
      before { tag.dup.save! }

      it { should be_invalid }
    end
  end
end
