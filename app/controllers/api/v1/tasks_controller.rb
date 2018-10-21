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
        task = find_task

        save_task(task)
      end

      def destroy
        task = find_task

        task.destroy
        render status: :no_content
      end

      private

      def find_task
        Task.find(params[:id])
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
