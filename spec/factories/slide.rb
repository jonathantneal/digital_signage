FactoryGirl.define do
  factory :slide do
    department
    sequence(:title) { |n| "Slide #{n}"}

    editable_content 'This is the content of the slide'
  end
end