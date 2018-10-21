require "active_model_uniqueness_validator"

class TagForm < Patterns::Form
  attribute :title, String

  validates :title, presence: true
  validates :title, active_model_uniqueness: { model: Tag }, if: :title_changed?

  private

  def title_changed?
    resource.title != attributes[:title]
  end

  def persist
    resource.update_attributes(attributes)
  end
end
