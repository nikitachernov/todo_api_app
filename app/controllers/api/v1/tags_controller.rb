module Api
  module V1
    class TagsController < ApplicationController
      def index
        tags = TagsQuery.call

        render json: tags
      end

      def create
        tag = Tag.new

        save_tag(tag, status: :created)
      end

      def update
        tag = find_tag

        save_tag(tag)
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

      def save_tag(tag, status: :ok)
        tag_form = TagForm.new(tag, resource_params)

        if tag_form.save
          render json: tag, status: status
        else
          render_errors(tag_form)
        end
      end
    end
  end
end
