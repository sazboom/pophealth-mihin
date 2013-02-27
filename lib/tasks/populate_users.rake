require ::File.expand_path('../../../config/environment',  __FILE__)
require 'csv'
namespace :users do
  desc 'Populate users from db/users.csv file'
  task :populate do
    CSV.foreach(::File.expand_path('../../../db/users.csv',  __FILE__),{:headers=>:first_row}) do |row|
      user = User.where(:email => row[4]).first
      if user
        puts 'Found user, updating'
        user.update_attributes(
                         :first_name =>     row[0].to_s,
                         :last_name =>      row[1].to_s,
                         :username =>       row[2].to_s,
                         :password =>       row[3].to_s)
      else 
        puts 'Did not find user, creating'
        admin_account = User.new(
                         :first_name =>     row[0].to_s,
                         :last_name =>      row[1].to_s,
                         :username =>       row[2].to_s,
                         :password =>       row[3].to_s,
                         :email =>          row[4].to_s,
                         :agree_license =>  true,
                         :admin =>          row[5].to_s == 'true',
                         :approved =>       true)
        admin_account.save!
      end
    end
  end
end
