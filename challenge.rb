#!/usr/bin/env ruby

require 'json'
require_relative 'services/top_up/top_up.service'
require_relative 'collections/users.collection'
require_relative 'collections/companies.collection'

##
# This is the answer code for Takehome v5.  See challenge.txt for the requirements.
# 
# This program reads in a JSON list of companies from a file, provided as command line
# argument 1, and a JSON list of users from a file, provided as command line argument 2,
# and pretends to top up the token amount of each user, with each company's top up amount.
# A report is produced indicating changes to users' token balances, but the changes to 
# the users' balances are not stored back to the harddrive. 


##
# Prints the instructions for running the program
def print_instructions
  puts "Use: ruby challenge.rb companies.json users.json"
end

##
# Opens a file for writing, and ensures it is closed once the passed block is executed,
# and even if the block errors out.
# 
# Params:
#  * <tt>file_name</tt> - The name of the file to open for writing
def with_file_out(file_name)
  file = open(file_name, 'w')
  yield(file)
ensure
  file.close if file
end

##
# -- MAIN --
#
if __FILE__ == $0
    begin
      # check if arg 1 exists
      if ARGV.size < 1 || ARGV[0].nil? || ARGV[0].empty?
        raise "Missing argument 1 (companies data file name)"
      end
      
      # check if arg 2 exists
      if ARGV.size < 2 || ARGV[1].nil? || ARGV[1].empty?
        raise "Missing argument 2 (users data file name)"
      end
      
      # read file, parse as JSON, instantiate Companies collection
      companies_file = File.read(ARGV[0])
      companies_hash = JSON.parse(companies_file)
      companies = Companies.new companies_hash
      
      # read file, parse as JSON, instantiate Users collection
      users_file = File.read(ARGV[1])
      users_hash = JSON.parse(users_file)
      users = Users.new users_hash
      
      # open the output file
      with_file_out "output.txt" do |output|
        # instantiate the Top Up service, and top up all companies
        top_up_service = TopUp::TopUpService.new(companies: companies, users: users, output: output)
        top_up_service.top_up_all_companies
      end
    
      puts "Completed Successfully!  Check output.txt"
    rescue StandardError => ex
      puts ex.message
    ensure
      # Print the run instructions after every execution
      puts "\n"
      print_instructions
    end  
end