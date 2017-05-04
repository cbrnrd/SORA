javac extern/*.java Client.java
jar cf $1 Client.class extern/*.class
rm -r *.class extern/*.class
