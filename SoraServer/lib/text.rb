require 'colorize'

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
