require "rails_helper"

RSpec.describe Task, type: :request do
  let(:valid_attributes) { { title: "Wash Laundry" } }
  let(:invalid_attributes) { { title: "" } }

  describe "GET #index" do
    before do
      create_list(:task, 3)
      get "/api/v1/tasks"
    end

    it "returns a success response" do
      expect(response).to have_http_status(:success)
    end

    it "returns 3 tasks" do
      expect(response.body).to have_json_size(3).at_path("data")
    end

    it "returns tasks in correct schema" do
      expect(response).to match_response_schema("tasks/tasks")
    end
  end

  describe "POST #create" do
    let(:create_task) do
      lambda do |attributes|
        post "/api/v1/tasks", params: {
          data: {
            type: "undefined",
            id: "undefined",
            attributes: attributes,
          },
        }
      end
    end

    context "with valid params" do
      it "creates a new Task" do
        expect { create_task.call(valid_attributes) }.to change(Task, :count).by(1)
      end

      context "when after create" do
        before { create_task.call(valid_attributes) }

        it "returns a created response" do
          create_task.call(valid_attributes)

          expect(response).to have_http_status(:created)
        end

        it "returns a task" do
          create_task.call(valid_attributes)

          expect(response).to match_response_schema("tasks/task")
        end
      end
    end

    context "with invalid params" do
      it "doesn't create a new Task" do
        expect { create_task.call(invalid_attributes) }.not_to change(Task, :count)
      end

      context "when after create" do
        before { create_task.call(invalid_attributes) }

        it "returns an unprocessable entity response" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns 1 error" do
          expect(response.body).to have_json_size(1).at_path("errors")
        end

        it "returns errors in correct schema" do
          expect(response).to match_response_schema("errors")
        end
      end
    end
  end

  describe "PUT #update" do
    let(:update_task) do
      lambda do |id, attributes|
        put "/api/v1/tasks/#{id}", params: {
          data: {
            type: "tasks",
            id: id,
            attributes: attributes,
          },
        }
      end
    end

    let(:task) { create(:task) }

    before { update_task.call(task.to_param, new_attributes) }

    context "with valid params" do
      let(:new_attributes) { { title: task.title.reverse } }

      it "updates the requested task" do
        task.reload

        expect(task.title).to eq(new_attributes[:title])
      end

      it "returns an ok response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a task" do
        expect(response).to match_response_schema("tasks/task")
      end
    end

    context "with invalid params" do
      let(:new_attributes) { { title: "" } }

      it "doesn't update a task" do
      end

      it "returns an unprocessable entity response" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns 1 error" do
        expect(response.body).to have_json_size(1).at_path("errors")
      end

      it "returns errors in correct schema" do
        expect(response).to match_response_schema("errors")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:delete_task) do
      lambda do |id|
        delete "/api/v1/tasks/#{task.to_param}"
      end
    end

    let(:task) { Task.first }

    before { create(:task) }

    it "destroys the requested task" do
      expect { delete_task.call(task.to_param) }.to change(Task, :count).by(-1)
    end

    context "when after destroy" do
      before { delete_task.call(task.to_param) }

      it "returns a no content response" do
        expect(response).to have_http_status(:no_content)
      end

      it "returns empty response" do
        expect(response.body).to be_blank
      end
    end
  end
end
