module TopUp
    
end

class TopUp::CompanyTopUpResult
  attr_reader :users_emailed
  attr_reader :users_not_emailed
  attr_accessor :total
  
  def initialize
    @users_emailed = []
    @users_not_emailed = []   
    @total = 0   
  end
end