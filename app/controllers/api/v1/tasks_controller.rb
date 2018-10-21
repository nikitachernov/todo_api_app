module Api
  module V1
    class TasksController < ApplicationController
      def index
        tasks = TasksWithTagsQuery.call

        render json: tasks
      end

      def create
        task = Task.new

        save_task(task, status: :created)
      end

      def update
        find_task do |task|
          save_task(task)
        end
      end

      def destroy
        find_task do |task|
          task.destroy
          render status: :no_content
        end
      end

      private

      def find_task
        tag = Task.find_by_id(params[:id])

        if tag
          yield tag
        else
          render_not_found
        end
      end

      def save_task(task, status: :ok)
        task_form = TaskForm.new(task, resource_params)

        if task_form.save
          render json: task, status: status
        else
          render_errors(task_form)
        end
      end
    end
  end
end
