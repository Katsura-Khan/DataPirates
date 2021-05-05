package com.company;

import java.sql.*;

public class conn{
    Connection c;
    Statement s;
    public conn(){
        try{
            Class.forName("oracle.jdbc.driver.OracleDriver");
            c =DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl","system","hr");
            s =c.createStatement();



        }catch(Exception e){
            System.out.println(e);
        }
    }
}
