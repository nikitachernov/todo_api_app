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
        find_tag do |tag|
          save_tag(tag)
        end
      end

      def destroy
        find_tag do |tag|
          tag.destroy
          render status: :no_content
        end
      end

      private

      def find_tag
        tag = Tag.find_by_id(params[:id])

        if tag
          yield tag
        else
          render_not_found
        end
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
