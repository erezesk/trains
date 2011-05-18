require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Erez Esk",
                         :email => "erezesk@gmail.com",
                         :origin => "3700",
                         :destination => "9100",
                         :password => "trains",
                         :password_confirmation => "trains")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "user-#{n+1}@randomuser.com"
      origin = "3700"
      destination = "9100"
      password = "password"
      User.create!(:name => name,
                   :email => email,
                   :origin => origin,
                   :destination => destination,
                   :password => password,
                   :password_confirmation => password)
    end
    Rake::Task['db:update_stations'].invoke
  end
end
