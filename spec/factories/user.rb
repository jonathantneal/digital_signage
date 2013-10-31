FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "johnd#{n}"}
    first_name 'John'
    last_name 'Doe'
    full_name { "#{first_name} #{last_name}" }
    sequence(:email) {|n| "john.doe#{n}@example.com"}
    title 'Imaginary Man'
    department 'Office of Imagination'
    photo_url ''
    sequence(:employee_id) {|n| n }

    factory :employee do
      after(:create) do |user|
        user.update_roles!(['employee'], :affiliation)
      end
    end

    factory :student do
      after(:create) do |user|
        user.update_roles!(['student'], :affiliation)
      end
    end

    factory :admin do
      after(:create) do |user|
        user.update_roles!(['admin'], :affiliation)
      end
    end
  end

  factory :role do
    trait :admin do
      name "admin"
    end
  end
end