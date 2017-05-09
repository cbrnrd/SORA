#
# The library file to do basic networking stuff (for bot interaction)
#

require 'geoip'

@SORA_LIB_BASE = File.expand_path File.dirname(__FILE__)

# Get the local ip
def local_ip
  orig = Socket.do_not_reverse_lookup
  Socket.do_not_reverse_lookup = true # turn off reverse DNS resolution temporarily
  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1 #google
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig # turn reverse DNS resolution back on
end

# Pass the ip and client socket into the function
# TODO: Format the output so it looks nice
def geolocate(ip)
  c = GeoIP.new("#{@SORA_LIB_BASE}/data/GeoLiteCity.dat").city(ip)
  data = ''
  data << "IP: #{c[1]}\n"
  data << "Continent: #{c[5]}\n"
  data << "Country: #{c[4]}\n"
  data << "Region: #{c.real_region_name}\n"
  data << "City: #{c[7]}\n"
  data << "Longitude: #{c.longitude} (about)\n"
  data << "Latitude: #{c.latitude} (about)\n"
  return data
end
