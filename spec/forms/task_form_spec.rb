require "rails_helper"

RSpec.describe Task do
  subject { task_form }

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

      it "has 3 tags" do
        task_form.save
        task.reload

        expect(task.tags.map(&:title)).to eq(tag_titles)
      end

      context "when new tags" do
        it "creates 3 tags" do
          expect { task_form.save }.to change(Tag, :count).by(3)
        end
      end

      context "when existing tags" do
        before { create(:tag, title: tag_titles.first) }

        it "creates 2 tags" do
          expect { task_form.save }.to change(Tag, :count).by(2)
        end
      end
    end

    context "when invalid attributes" do
      let(:title) { "" }

      it { should be_invalid }
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

      context "when with new tags" do
        it "has 3 tags" do
          task_form.save
          task.reload

          expect(task.tags.map(&:title)).to eq(tag_titles)
        end
      end

      context "when without new tags" do
        let(:params) { { title: title } }

        it "has 5 tags" do
          task_form.save
          task.reload

          expect(task.tags.count).to eq(5)
        end

        it "creates 0 tags" do
          expect { task_form.save }.not_to change(Tag, :count)
        end
      end

      context "when without tags" do
        let(:params) { { title: title, tags: [] } }

        it "has 0 tags" do
          task_form.save
          task.reload

          expect(task.tags.count).to eq(0)
        end
      end
    end

    context "when invalid attributes" do
      let(:new_title) { "" }

      it { should be_invalid }
    end
  end
end
