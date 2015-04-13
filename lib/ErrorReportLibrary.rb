class ErrorReport
  def initialize(row=0,col=0,incorrect_value = "", expected_criteria="",cause="")
    @row = row
    @col = col
    @incorrect_value = incorrect_value
    @expected_criteria = expected_criteria 
    @cause = cause
  end
  def print
    printf($printFormat,@row,@col,@incorrect_value, @expected_criteria, @cause)
  end
  def tableRowFormat
    return "<tr><td>#{@row}</td><td>#{@col}</td><td>#{@incorrect_value}</td><td>#{@expected_criteria}</td><td>#{@cause}</td></tr>"
  end
end
