module Api
  module V1
    class TasksController < ApplicationController
      def index
        tasks = Task.all

        render json: tasks
      end

      def create
        task = Task.new(task_params)

        if task.save
          render json: task, status: :created
        else
          render_errors(task)
        end
      end

      def update
        task = find_task

        if task.update(task_params)
          render json: task
        else
          render_errors(task)
        end
      end

      def destroy
        task = find_task

        task.destroy
      end

      private

      def find_task
        Task.find(params[:id])
      end

      def task_params
        unpermitted_params = ActiveModelSerializers::Adapter::JsonApi::Deserialization.parse(params)
        ActionController::Parameters.new(unpermitted_params).permit(:title)
      end
    end
  end
end
