# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Erez Esk"
  user.email                 "erez@gmail.com"
  user.origin                "3700"
  user.destination           "9100"
  user.password              "testpass"
  user.password_confirmation "testpass"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
