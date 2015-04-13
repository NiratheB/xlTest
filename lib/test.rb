require 'rubygems'
require 'roo'
require_relative 'ColumnLibrary'
require_relative 'ErrorReportLibrary'
require_relative 'HTML_Editor'
$printFormat = "%-10s\t%-10s\t%-20s\t%-30s\t%-30s\n"





variables = Hash.new(0)
dir = Dir.pwd.to_s
dir.gsub!(/lib\Z/, "test_data/module_1")
#puts dir


#get variables from conf
conf_file = File.new(dir+"/"+"conf")
while line = conf_file.gets
  if line[0]!='#' and line=~ /\w/
    #puts line
    if line =~ /(.*)=(.*)/
      var_name = $1
      value = $2
      variables[var_name]= value
    end
  end
end


#read column specification
expected_data_file = File.new(dir+"/"+"expected_data")
columns = []
while line = expected_data_file.gets
  if line[0]!='#' and line=~ /\w/
    #puts line
    if line =~ /column(\d)=(\w+),(\w+),(.*)/
      #puts "ok"
      type = $2
      if $3 == "true"
        required = true
      else
        required = false
      end
      regex = $4
      columns[$1.to_i] = Column.new(type,required,regex)
    end
  end
end



#read from excel file
filename = dir+"/"+variables["source_file_name"]
workbook = Roo::OpenOffice.new(filename)

count =0
workbook.each do |row|
  count+=1
end

errorCount = 0
errorReport = []
(variables["start_from_line_no"].to_i..workbook.last_row).each do |row|
  matched = true
  (workbook.first_column .. workbook.last_column).each do |col|
    unless columns[col].nil?
      matchReport = columns[col].matches(workbook.row(row)[col-1])
      unless matchReport == :all
        # error generated
        matched = false
        value = workbook.row(row)[col-1]
        expected_criteria = columns[col].getExpectedCriteria(matchReport)
        cause = columns[col].getErrorMessage(matchReport)
        errorReport.push(ErrorReport.new(row,col,value,expected_criteria,cause))
        break
      end
    end
  end
  if matched == false
    errorCount+=1
  end
end


puts "Total Error(s) = "+ errorCount.to_s
puts

printf($printFormat,"Row","Column","Input value","Expected criteria","Cause")
printf($printFormat,"---","------","-----------","-----------------", "-----")
header = ["Row","Column","Input value","Expected criteria","Cause"]

html = HTML_Editor.new("report")
html.beginDoc
html.writeTable(errorReport,header)
html.endDoc
errorReport.each do |error|
  error.print
end