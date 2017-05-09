require 'colorize'

DEBUG_STATUS = true

def print_status(msg='')
  ind = "[!] ".colorize(:blue)
  puts "#{ind}#{msg}"
end

def print_good(msg='')
  ind = "[!] ".colorize(:green)
  puts "#{ind}#{msg}"
end

def print_err(msg='')
  ind = "[!] ".colorize(:red)
  puts "#{ind}#{msg}"
end

def sprint_status(msg='', socket)
  ind = "[!] ".colorize(:blue)
  socket.puts "#{ind}#{msg}"
end

def sprint_good(msg='', socket)
  ind = "[!] ".colorize(:green)
  socket.puts "#{ind}#{msg}"
end

def sprint_err(msg='', socket)
  ind = "[!] ".colorize(:red)
  socket.puts "#{ind}#{msg}"
end

def sdebug(msg='', socket)
  if DEBUG_STATUS
    ind = '[!] '.colorize(:yellow)
    socket.puts "#{ind}#{msg}"
  end
end
