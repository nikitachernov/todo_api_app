require "active_model_uniqueness_validator"

class TagForm < Patterns::Form
  attribute :title, String

  validates :title, presence: true, active_model_uniqueness: { model: Tag }

  private

  def persist
    resource.update_attributes(attributes)
  end
end
