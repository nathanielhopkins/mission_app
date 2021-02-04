require "faker"

FactoryBot.define do
  factory :goal do
    title { Faker::Lorem.words(number: 3).join(" ") }
    details { Faker::Lorem.words(number: 5).join(" ") }
  end
end
