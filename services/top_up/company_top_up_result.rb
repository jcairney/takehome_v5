module TopUp
end

##
# A storage structure for information pertaining to updating the token balances of all
# users of a company.
class TopUp::CompanyTopUpResult
  attr_reader :users_emailed
  attr_reader :users_not_emailed
  attr_accessor :total
  
  ##
  # Initializes the structure with empty lists and a balance changes total of 0.
  def initialize
    @users_emailed = []
    @users_not_emailed = []   
    @total = 0   
  end
end