require_relative('../models/user.model')

class Users
  def initialize(users_hash)
    @users_by_id = Hash.new
    # We want a hash with an array of users as value for each company ID used as key
    @users_by_company_id = Hash.new{|hash, key| hash[key] = [] }

    # For each user in the JSON hash, store it as a proper object in the collection
    users_hash.each do |user_hash|
      begin
        # Store the expected JSON fields, whether present or not, into a new User object
        user = User.new(
          id: user_hash["id"],
          first_name: user_hash["first_name"],
          last_name: user_hash["last_name"],
          email: user_hash["email"],
          company_id: user_hash["company_id"],
          email_status: user_hash["email_status"],
          active_status: user_hash["active_status"],
          tokens: user_hash["tokens"],
          )
          
          # raise KeyError.new("User with this id already exists: #{user.id}.") unless @users_by_id[user.id].nil?
          if !@users_by_id[user.id].nil? 
            puts "Warning: User with this ID already exists: #{user.id}. Sample_output.txt suggests we should ignore this."
            puts "It's a good thing we do not need to find users by ID in this version!"
          end

          # Store the user object in the collection, indexed by company ID, and/or user ID
          @users_by_id[user.id] = user # We don't need this, but commonly, we would.
          @users_by_company_id[user.company_id] << user
      rescue StandardError => ex
        puts ex.message
        puts "\tCannot create user.  Skipping."
      end
    end
  end
  
  def users_by_company_id(company_id)
    # Look up the list of users for this company ID, and sort it by Last Name, then First Name.
    @users_by_company_id[company_id].sort{ |a,b| "#{a.last_name}, #{a.first_name}" <=> "#{b.last_name}, #{b.first_name}" }
  end
end