class Column
  
  attr_reader :regex
  
  def toRubyRegex(value)
    return "\\A#{value}+\\Z"
  end
  
  def initialize(type="string",required= false, regex = ".*")
    @type = type
    @required = required
    if @type == "date"
      regex.gsub!(/\w/ ,"\\d")
    end
    regex = toRubyRegex(regex)
    @regex =Regexp.new(regex)
  end
  
  
  def print
    puts "Data Type " + @type
    puts "Required " + @required.to_s
    puts "Regex " + @regex.to_s
  end
  
  def is_number?(value)
    true if Float(value) rescue false
  end
  
  def is_date?(value)
    true if Date.parse(value) rescue false
  end
  
  def getErrorMessage(value)
    return "Empty Required Field" if value == :requiredError
    return "Mismatched Data Type" if value == :dataTypeError
    return "Regular Expression did not match!" if value ==:regexError
  end
  
  def getErrorCause(value)
    return :requiredError unless matchesRequired?(value)
    return :dataTypeError unless matchesType?(value)
    return :regexError unless matchesRegex?(value)
    return :noError
  end
  
  def getExpectedCriteria(value)
    case value
      when :requiredError then return "Required = "+@required.to_s
      when :dataTypeError then return "Data Type = "+@type.to_s
      when  :regexError then return "Regex = " +@regex.to_s
    end
  end
  
  def matches(value)
    if @required == false && value.nil?
      return :all
    end 
    errorCause = getErrorCause(value)
    
    return :all if errorCause == :noError
    return errorCause 
  end
  
  
  
  def matchesType?(value)
    case @type
    when "string" then return true
    when "number" then return is_number?(value)
    when "date" then return is_date?(value)
    end
    return false
  end
  
  def matchesRequired?(value)
    if @required==true
      if value.nil? || value.to_s==""
        return false
      end
    end
    return true
  end
  
  def matchesRegex?(value)
    valueString = value.to_s
    #puts @regex
    if valueString =~ @regex
      return true
    else
      return false
    end
  end
  
  
end