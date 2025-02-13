FactoryBot.define do
  factory :jwt_blacklist do
    jti { "MyString" }
    exp { "2025-02-11 11:59:43" }
  end
end
