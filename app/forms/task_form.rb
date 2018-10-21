class TaskForm < Patterns::Form
  attribute :title, String
  attribute :tags, Array

  validates :title, presence: true

  private

  def tag_ids
    tag_titles = tags.select(&:present?)

    existing_tags = Tag.where(title: tag_titles)

    new_tag_titles = tag_titles - existing_tags.map(&:title)

    new_tags = new_tag_titles.map { |title| Tag.create!(title: title) }

    (existing_tags + new_tags).map(&:id)
  end

  def persist
    resource.update_attributes(title: attributes[:title], tag_ids: tag_ids)
  end
end
