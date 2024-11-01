##
# Structure to store information about a company
class Company
  attr_reader :id
  attr_reader :name
  attr_reader :top_up
  attr_reader :email_status

  ##
  # Initializes the Company object with a required set of fields.
  def initialize(id:, name: nil, top_up:, email_status: false)
        @id = id
        @name = name.to_s
        @top_up = Float(top_up)
        @email_status = !!email_status

        validate!
  end

  ##
  # Validates the inputs to the Company initializer
  def validate!
    context = "Error processing company #{@name}, ID: #{@id}:"
    raise ArgumentError.new("#{context} id field must exist.") if @id.nil?
    raise ArgumentError.new("#{context} top_up must be greater than zero.") unless @top_up > 0
  end
end