require_relative '../models/company.model'

##
# A collection of <tt>Company</tt> objects, with methods for retrieving the list of companies
# in ordered by one property or another.
class Companies
  ##
  # Initializes the collection, turning hashed JSON into proper <tt>Company</tt> objects.
  # 
  #Params:
  # * <tt>companies_hash</tt> - A hash from JSON.parse(), containing a list of companies.
  def initialize(companies_hash)
    @companies_by_id = Hash.new

    companies_hash.each do |company_hash|
      begin
        # Store the expected JSON fields, whether present or not, into a new Company object
        company = Company.new(
          id: company_hash["id"],
          name: company_hash["name"],
          top_up: company_hash["top_up"],
          email_status: company_hash["email_status"]
          )
          
        raise KeyError.new("Company with this id (#{company.id} already exists.") unless @companies_by_id[company.id].nil?
        # Index the company in the collection by company ID
        @companies_by_id[company.id] = company
      rescue StandardError => ex
        puts ex.message
        puts "\tCannot create company.  Skipping."
      end
    end
  end

  ##
  # Returns the full list of companies, sorted alphabetically by ID.
  def all_companies_by_id
    # return array of key value pairs from the hash, sorted by company ID
    @companies_by_id.sort_by { |key| key.to_s }
  end
end