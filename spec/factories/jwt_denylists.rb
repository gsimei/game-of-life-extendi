FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-02-11 11:59:43" }
  end
end
