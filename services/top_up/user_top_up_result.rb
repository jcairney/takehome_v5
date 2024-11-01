module TopUp
    
end

class TopUp::UserTopUpResult
  attr_reader :user
  attr_accessor :previous_balance
  attr_accessor :new_balance
  attr_accessor :emailed

  def initialize(user)
        @user = user
        @emailed = false
  end
end