FactoryGirl.define do
  factory :department do
    sequence(:title) { |n| "Department #{n}"}
  end
end