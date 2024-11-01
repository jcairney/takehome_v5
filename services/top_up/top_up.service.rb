require_relative "user_top_up_result"
require_relative "company_top_up_result"

module TopUp
    
end

class TopUp::TopUpService

  def initialize(companies:, users:, output:)
      @companies = companies
      @users = users
      @output = output
  end

  def top_up_all_companies()
    @output.write("\n")

    # Get the companies in alphabetical order, and process each one
    @companies.all_companies_by_id.each do |id, company|
      # main work happens here.  Everything after is just formatting the report.
      company_top_up_result = top_up_company company

      if company_top_up_result.total == 0
        next # sample_output.txt suggests we should not output if no work was done
      end

      @output.write("\tCompany Id: #{company.id}\n")
      @output.write("\tCompany Name: #{company.name}\n")
      
      @output.write("\tUsers Emailed:\n")
      # print reports of each emailed user
      company_top_up_result.users_emailed.each do |user_top_up_result|
        print_user_top_up_results_report user_top_up_result
      end
      
      @output.write("\tUsers Not Emailed:\n")
      # print reports of each user not emailed
      company_top_up_result.users_not_emailed.each do |user_top_up_result|
        print_user_top_up_results_report user_top_up_result
      end
      
      @output.write("\t\tTotal amount of top ups for #{company.name}: #{Integer(company_top_up_result.total)}\n")
      @output.write("\n")
    end
  end

  private
  def top_up_company(company)
    if company.nil? || company.id.nil?
      puts "Error: Could not top up because company or company ID is nil.  Skipping."
      return
    end
    
    company_top_up_result = TopUp::CompanyTopUpResult.new
    # Get users sorted alphabetically by Last Name
    company_users = @users.users_by_company_id(company.id)
    # Top up each active user with this company's top up amount
    company_users.each do |user|
      next unless user.active_status # Do we need to log this skip to output?
      # Do the top up work
      user_top_up_result = top_up_user(user, company.top_up, company.email_status)
      # Bucket based on whether user was emailed during top up.
      (user_top_up_result.emailed ? company_top_up_result.users_emailed : company_top_up_result.users_not_emailed).push(user_top_up_result)
      # increase the company's total topped up amount
      company_top_up_result.total += company.top_up
    end

    company_top_up_result
  end

  def top_up_user(user, amount, company_email_status)
    # Initialize result container for user
    user_top_up_result = TopUp::UserTopUpResult.new user
    
    # Decide whether we should (or even can) email the user
    should_email = company_email_status && user.email_status
    if should_email && user.email.nil?
      puts "Cannot email user #{user.id} because email address is missing."
      should_email = false
    end
    
    # Record the original balance, then update it
    user_top_up_result.previous_balance = user.tokens
    user.tokens = Integer(user.tokens + amount)
    user_top_up_result.new_balance = user.tokens
    # If this user model were connected to a database, we would call .save() on the model, or call some other function to update the db.

    if should_email
      # email the user, and mark that we did, if successful
      user_top_up_result.emailed = email_user user
    end
    
    user_top_up_result
  end

  def email_user(user)
    # do nothing in this version
    true
  end

  def print_user_top_up_results_report user_top_up_result
    @output.write("\t\t#{user_top_up_result.user.last_name}, #{user_top_up_result.user.first_name}, #{user_top_up_result.user.email}\n")
    @output.write("\t\t  Previous Token Balance, #{user_top_up_result.previous_balance}\n")
    @output.write("\t\t  New Token Balance #{user_top_up_result.new_balance}\n")
  end
end 