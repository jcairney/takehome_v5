class User
    attr_reader :id # number
		attr_reader :first_name # string
		attr_reader :last_name # string
		attr_reader :email # string
		attr_reader :company_id # number
		attr_reader :email_status# boolean
		attr_reader :active_status # boolean,
		attr_accessor :tokens # number

    # TODO: Use Struct to reduce boilerplate?
    def initialize(id:, first_name:"", last_name:"", email: nil, company_id:, email_status: false, active_status: false, tokens: 0)
      @id = id
      @first_name = first_name
      @last_name = last_name
      @email = email
      @company_id = company_id
      @email_status = !!email_status
      @active_status = !!active_status
      @tokens = Integer(tokens)

      validate!
    end

    def validate!
      context = "Error processing user ID: #{@id}:" # Do not include users' names in logs, for HIPAA reasons
      raise ArgumentError.new("#{context} id field must exist.") if @id.nil?
      raise ArgumentError.new("#{context} tokens must be greater than zero.") unless @tokens >= 0
    end
end