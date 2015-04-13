class HTML_Editor
  def initialize(filename = "output",dir = "test_report/module_1")
    @filename = filename + ".html"
    @dir = Dir.pwd.to_s
    @dir.gsub!(/lib\Z/, dir)
    @file = File.open(@dir+ "/"+@filename,'w')
  end
  
  
  
  def beginTable
    @file.write("<table border=\"1\" style=\"width:100%\">\n")
  end
  
  def endTable
    @file.write("</table>\n")
  end
  
  def beginDoc
    @file.write("<!DOCTYPE html>
<html>
<body>")
  end
  def endDoc
    @file.write("
</body>
</html>")
  end
  
  def writeHeader(header)
    @file.write("<tr>")
    
    header.each do |item|
      @file.write("<th>#{item}</th>")
    end
    
    @file.write("</tr>")
  end
  
  def writeTable(array,header = Array.new)
    beginTable
    writeHeader(header)
    array.each do |item|
      @file.write(item.tableRowFormat)
    end
    endTable
  end
end