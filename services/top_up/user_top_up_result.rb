module TopUp
end

##
# A storage structure for information to report about updating a user's token balance
class TopUp::UserTopUpResult
  attr_reader :user
  attr_accessor :previous_balance
  attr_accessor :new_balance
  attr_accessor :emailed

  ##
  # Initializes the structure with the <tt>User</tt> being updated.
  def initialize(user)
        @user = user
        @emailed = false
  end
end