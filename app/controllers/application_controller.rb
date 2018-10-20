class ApplicationController < ActionController::API
  def render_errors(object)
    render(
      json: object,
      status: :unprocessable_entity,
      serializer: ActiveModel::Serializer::ErrorSerializer
    )
  end
end
