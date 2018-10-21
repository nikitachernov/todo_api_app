FactoryBot.define do
  factory :task do
    sequence :title do |n|
      "Task #{n}"
    end

    transient do
      tags_count { 5 }
    end

    after(:create) do |task, evaluator|
      create_list(:tag, evaluator.tags_count, tasks: [task])
    end
  end
end
