module Api
  module V1
    class TagsController < ApplicationController
      def index
        tags = Tag.all

        render json: tags
      end

      def create
        tag = Tag.new(tag_params)

        if tag.save
          render json: tag, status: :created
        else
          render_errors(tag)
        end
      end

      def update
        tag = find_tag

        if tag.update(tag_params)
          render json: tag
        else
          render_errors(tag)
        end
      end

      def destroy
        tag = find_tag

        tag.destroy
        render status: :no_content
      end

      private

      def find_tag
        Tag.find(params[:id])
      end

      def tag_params
        unpermitted_params = ActiveModelSerializers::Adapter::JsonApi::Deserialization.parse(params)
        ActionController::Parameters.new(unpermitted_params).permit(:title)
      end
    end
  end
end
