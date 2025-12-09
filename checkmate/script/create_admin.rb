#!/usr/bin/env ruby
ENV['RAILS_ENV'] ||= 'development' # Default to development if not already set
require_relative '../config/environment'

puts 'Starting script...'
puts 'please enter your email'
email = gets.chomp
puts "adding email #{email}"
Rails.logger.info User.all.inspect
user_data = User.find_by(email: email)

unless user_data
  puts "Error: No user found with email '#{email}'"
  exit 1
end

uid = user_data.id

user_datum = UserDatum.find_by(user_id: uid)
UserDatum.create(user_id: uid, email: email) unless user_datum

system_org = Organization.find_by(org_name: :system)
unless system_org
  puts "Error: 'system' organization not found"
  exit 1
end

oid = system_org.org_id
OrgRole.find_or_create_by(org_id: oid, user_id: uid) do |role|
  role.user_role = :admin
end

puts "Success! User '#{email}' is now an admin in the system organization"

# ruby script/create_admin.rb
