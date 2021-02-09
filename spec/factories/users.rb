require "faker"

FactoryBot.define do
  factory :user do
    username { "bob49" }
    password { "bobpassword" }

    factory :random_user do
      username { Faker::Internet.user_name }
      password { "password" }
    end
  end
end
