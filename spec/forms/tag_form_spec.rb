require "rails_helper"

RSpec.describe Tag do
  subject { tag_form }

  let(:tag_form) { TagForm.new(tag, params) }

  context "when create" do
    let(:tag) { Tag.new }
    let(:params) { { title: title } }

    context "when valid attributes" do
      let(:title) { "Home" }

      it { should be_valid }

      it "increases tag count" do
        expect { tag_form.save }.to change(Tag, :count).by(1)
      end

      context "when duplicate" do
        before { create(:tag, title: title) }

        it { should be_invalid }
      end
    end

    context "when invalid attributes" do
      let(:title) { "" }

      it { should be_invalid }
    end
  end

  context "when update" do
    before { create(:tag, title: title) }

    let(:tag) { Tag.first }
    let(:params) { { title: new_title } }
    let(:title) { "Work" }

    context "when valid attributes" do
      let(:new_title) { "Home" }

      it { should be_valid }

      it "updates tag title" do
        tag_form.save
        tag.reload

        expect(tag.title).to eq(new_title)
      end
    end

    context "when invalid attributes" do
      let(:new_title) { "" }

      it { should be_invalid }
    end
  end
end
