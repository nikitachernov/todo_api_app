class ApplicationController < ActionController::API
  def resource_params
    ActiveModelSerializers::Adapter::JsonApi::Deserialization.parse(params)
  end

  def render_not_found
    render status: :not_found
  end

  def render_errors(object)
    render(
      json: object,
      status: :unprocessable_entity,
      serializer: ActiveModel::Serializer::ErrorSerializer
    )
  end
end
