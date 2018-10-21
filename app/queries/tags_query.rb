class TagsQuery < Patterns::Query
  queries Tag

  def query
    relation
  end
end
