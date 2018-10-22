class TaskForm < Patterns::Form
  attribute :title, String
  attribute :tags, Array

  validates :title, presence: true

  private

  def tags_changed?
    resource.tags != tags
  end

  def tag_ids
    return resource.tag_ids unless tags_changed?

    tag_titles = tags.select(&:present?)

    existing_tags = Tag.where(title: tag_titles)

    new_tag_titles = tag_titles - existing_tags.map(&:title)

    new_tags = new_tag_titles.map { |title| Tag.create!(title: title) }

    (existing_tags + new_tags).map(&:id)
  end

  def persist
    ActiveRecord::Base.transaction do
      resource.update_attributes(title: attributes[:title], tag_ids: tag_ids)
    end
  end
end
