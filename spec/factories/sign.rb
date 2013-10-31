FactoryGirl.define do
  factory :sign do
    department
    sequence(:name) { |n| "sign_#{n}"}
    sequence(:title) { |n| "Sign #{n}"}

    height 1920
    width 1080

    trait :with_email do
      email 'test@example.com'
    end
  end
end