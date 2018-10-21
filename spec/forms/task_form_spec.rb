require "rails_helper"

RSpec.describe Task do
  subject { task_form }

  before { create(:tag, title: "Home") }

  let(:task_form) { TaskForm.new(task, params) }
  let(:tag_titles) { ["Home", "Urgent", "Chores"] }

  context "when create" do
    let(:task) { Task.new }
    let(:params) { { title: title, tags: tag_titles } }

    context "when valid attributes" do
      let(:title) { "Wash Laundry" }

      it { should be_valid }

      it "increases task count" do
        expect { task_form.save }.to change(Task, :count).by(1)
      end

      it "creates 2 tags" do
        expect { task_form.save }.to change(Tag, :count).by(2)
      end

      it "has 3 tags" do
        task_form.save
        expect(task.tags.map(&:title)).to eq(tag_titles)
      end
    end

    context "when invalid attributes" do
      let(:title) { "" }

      it { should be_invalid }

      it "creates 0 tags" do
        expect { task_form.save }.not_to change(Tag, :count)
      end
    end
  end

  context "when update" do
    before { create(:task, title: title, tags_count: 5) }

    let(:task) { Task.first }
    let(:params) { { title: new_title, tags: tag_titles } }
    let(:title) { "Wash Laundry" }

    context "when valid attributes" do
      let(:new_title) { "Do Laundry" }

      it { should be_valid }

      it "updates task title" do
        task_form.save
        task.reload

        expect(task.title).to eq(new_title)
      end

      it "creates 2 tags" do
        expect { task_form.save }.to change(Tag, :count).by(2)
      end

      it "has 3 tags" do
        task_form.save
        task.reload

        expect(task.tags.map(&:title)).to eq(tag_titles)
      end
    end

    context "when invalid attributes" do
      let(:new_title) { "" }

      it { should be_invalid }
    end
  end
end
