FactoryBot.define do
  factory :tag do
    sequence :title do |n|
      "Tag #{n}"
    end
  end
end
