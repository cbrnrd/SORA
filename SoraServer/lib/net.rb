require 'geoip'
require 'core'

@SORA_LIB_BASE = File.expand_path File.dirname(__FILE__)

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

# Pass the ip and client socket into the function
def geolocate(ip, client)
  c = GeoIP.new("#{@SORA_LIB_BASE}/data/GeoLiteCity.dat").city(ip)
  client.puts c
end
