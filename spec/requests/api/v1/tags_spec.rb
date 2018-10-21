require "rails_helper"

RSpec.describe Tag, type: :request do
  let(:valid_attributes) { { title: "Wash Laundry" } }
  let(:invalid_attributes) { { title: "" } }

  describe "GET #index" do
    before do
      create_list(:tag, 3)
      get "/api/v1/tags"
    end

    it "returns a success response" do
      expect(response).to have_http_status(:success)
    end

    it "returns 3 tags" do
      expect(response.body).to have_json_size(3).at_path("data")
    end

    it "returns tags in correct schema" do
      expect(response).to match_response_schema("tags/tags")
    end
  end

  describe "POST #create" do
    let(:create_tag) do
      lambda do |attributes|
        post "/api/v1/tags", params: {
          data: {
            type: "undefined",
            id: "undefined",
            attributes: attributes,
          },
        }
      end
    end

    context "with valid params" do
      it "creates a new Tag" do
        expect { create_tag.call(valid_attributes) }.to change(Tag, :count).by(1)
      end

      context "when after create" do
        before { create_tag.call(valid_attributes) }

        it "returns a created response" do
          expect(response).to have_http_status(:created)
        end

        it "returns a tag" do
          expect(response).to match_response_schema("tags/tag")
        end
      end
    end

    context "with invalid params" do
      it "doesn't create a new Tag" do
        expect { create_tag.call(invalid_attributes) }.not_to change(Tag, :count)
      end

      context "when after create" do
        before { create_tag.call(invalid_attributes) }

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
    let(:update_tag) do
      lambda do |id, attributes|
        put "/api/v1/tags/#{id}", params: {
          data: {
            type: "tags",
            id: id,
            attributes: attributes,
          },
        }
      end
    end

    let(:tag) { create(:tag) }

    context "with valid params" do
      before { update_tag.call(tag.to_param, new_attributes) }

      let(:new_attributes) { { title: tag.title.reverse } }

      it "updates the requested tag" do
        tag.reload

        expect(tag.title).to eq(new_attributes[:title])
      end

      it "returns an ok response" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a tag" do
        expect(response).to match_response_schema("tags/tag")
      end
    end

    context "with invalid params" do
      before { update_tag.call(tag.to_param, new_attributes) }

      let(:new_attributes) { { title: "" } }

      it "doesn't update a tag" do
        tag.reload

        expect(tag.title).to be_present
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

    context "when not found" do
      before { update_tag.call("404", new_attributes) }

      let(:new_attributes) { {} }

      it "returns a not found response" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns empty response" do
        expect(response.body).to be_blank
      end
    end
  end

  describe "DELETE #destroy" do
    let(:delete_tag) do
      lambda do |id|
        delete "/api/v1/tags/#{id}"
      end
    end

    let(:tag) { Tag.first }

    before { create(:tag) }

    it "destroys the requested tag" do
      expect { delete_tag.call(tag.to_param) }.to change(Tag, :count).by(-1)
    end

    context "when after destroy" do
      before { delete_tag.call(tag.to_param) }

      it "returns a no content response" do
        expect(response).to have_http_status(:no_content)
      end

      it "returns empty response" do
        expect(response.body).to be_blank
      end
    end

    context "when not found" do
      before { delete_tag.call("404") }

      it "returns a not found response" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns empty response" do
        expect(response.body).to be_blank
      end
    end
  end
end
