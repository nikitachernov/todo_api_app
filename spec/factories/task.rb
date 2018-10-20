FactoryBot.define do
  factory :task do
    title { |n| "Task #{n}" }
  end
end
