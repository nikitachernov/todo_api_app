class TasksWithTagsQuery < Patterns::Query
  queries Task

  private

  def query
    relation.includes(:tags)
  end
end
