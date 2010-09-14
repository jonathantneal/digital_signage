require 'highline'

namespace :db do

  namespace :setup do

    desc "Create a new user"
    task :user => :environment do
    
      cli = HighLine.new
    
      user = User.new
      user.username = cli.ask("Username: ")
      user.first_name = cli.ask("First Name: ")
      user.last_name = cli.ask("Last Name: ")
      user.email = cli.ask("Email: ")
      user.roles = []
      User::ROLES.each do |role|
        if cli.agree("Grant #{role} role?")
          user.roles = (user.roles << role)
        end
      end
      
      if user.save
        puts "#{user.username} account created"
      else
        puts "Unable to create #{user.username} account"
        puts user.errors.full_messages
      end
    
    end
  
  end
  
end
