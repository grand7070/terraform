#!/bin/bash

# Install JDK & Tomcat & MySQL connector
sudo yum update -y
sudo yum install -y java-11-amazon-corretto-devel.x86_64

sudo wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.15/bin/apache-tomcat-10.1.15.tar.gz
sudo tar xzf apache-tomcat-10.1.15.tar.gz

sudo wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.23/mysql-connector-java-8.0.23.jar
mv mysql-connector-java-8.0.23.jar ./apache-tomcat-10.1.15/lib

# Get EC2 Instance info
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
RZAZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
IID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" 169.254.169.254/latest/meta-data/instance-id)
LIP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" 169.254.169.254/latest/meta-data/local-ipv4)

# Get DB info
DB_ADDRESS=${DB_ADDRESS}
DB_NAME=${DB_NAME}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}

# Update JAVA_HOME to run tomcat
echo "export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto.x86_64" >> /etc/profile
source /etc/profile

# Update JAVA_OPTS
JAVA_OPTS_SETTING="JAVA_OPTS=\"\$JAVA_OPTS -DRZAZ=$RZAZ -DIID=$IID -DLIP=$LIP -DDB_ADDRESS=$DB_ADDRESS -DDB_NAME=$DB_NAME -DDB_USERNAME=$DB_USERNAME -DDB_PASSWORD=$DB_PASSWORD\""
sed -i "2i $JAVA_OPTS_SETTING" ./apache-tomcat-10.1.15/bin/catalina.sh

# Make JSP
cat > ./apache-tomcat-10.1.15/webapps/ROOT/main.jsp <<EOF
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<h1>Terraform Three Tier</h1>
<h2>Web - WS(nginx)</h2>
<p>
RegionAz: <%= request.getHeader("X-WEB-AZ") %><br>
Instance ID: <%= request.getHeader("X-WEB-IID") %><br>
Private IP: <%= request.getHeader("X-WEB-IP") %><br>
</p>
<h2>App - WAS(tomcat)</h2>
<p>
RegionAz: <%= System.getProperty("RZAZ") %><br>
Instance ID: <%= System.getProperty("IID") %><br>
Private IP: <%= System.getProperty("LIP") %><br>
</p>
<h2>DB</h2>
<p>
DB_ENDPOINT: <%= "jdbc:mysql://" + System.getProperty("DB_ADDRESS") + "/" + System.getProperty("DB_NAME") %><br>
</p>
<%
    Connection conn = null;
    String dbMessage = "DB Connect Success!";
    String wsAz = request.getHeader("X-WEB-AZ");
    String wasAz = System.getProperty("RZAZ");
    String wsNumber = wsAz != null ? wsAz.substring(wsAz.length() - 1) : "";
    String wasNumber = wasAz != null ? wasAz.substring(wasAz.length() - 1) : "";
    boolean isSuccess = false;

    try{
        String url = "jdbc:mysql://" + System.getProperty("DB_ADDRESS") + "/" + System.getProperty("DB_NAME");
        String username = System.getProperty("DB_USERNAME");
        String password = System.getProperty("DB_PASSWORD"); // TODO
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
    } catch (Exception e) {
        dbMessage = "DB Connection Error: " + e.getMessage();
    }

    if (!wsNumber.isEmpty() && !wasNumber.isEmpty()) {
        isSuccess = true;
    }
%>
<p><%= dbMessage %></p>
<%
    if (isSuccess) {
%>
<h2>Connections</h2>
<h4>WS<%= wsNumber %>-WAS<%= wasNumber %>-DB</h4>
<%
    }
%>
EOF

# Start Tomcat
sudo ./apache-tomcat-10.1.15/bin/startup.sh