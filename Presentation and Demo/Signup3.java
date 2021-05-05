package com.company;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.sql.*;
import java.util.*;

public class Signup3 extends JFrame implements ActionListener{

    JLabel l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11;
    JRadioButton r1,r2,r3,r4;
    JButton b;
    JCheckBox c1,c2,c3,c4,c5,c6,c7;
    JTextField t1;




    Signup3(){

        setFont(new Font("System", Font.BOLD, 22));
        Font f = getFont();
        FontMetrics fm = getFontMetrics(f);
        int x = fm.stringWidth("NEW ACCOUNT APPLICATION FORM - PAGE 3");
        int y = fm.stringWidth(" ");
        int z = getWidth()/2 - (x/2);
        int w = z/y;
        String pad ="";
        //for (int i=0; i!=w; i++) pad +=" ";
        pad = String.format("%"+w+"s", pad);
        setTitle(pad+"NEW ACCOUNT APPLICATION FORM - PAGE 3");


        l1 = new JLabel("Page 3: Account Details");
        l1.setFont(new Font("Raleway", Font.BOLD, 22));

        l2 = new JLabel("Scholarship type:");
        l2.setFont(new Font("Raleway", Font.BOLD, 18));

        l3 = new JLabel("Card Number:");
        l3.setFont(new Font("Raleway", Font.BOLD, 18));

        l4 = new JLabel("XXXX-XXXX-XXXX-4184");
        l4.setFont(new Font("Raleway", Font.BOLD, 18));

        l5 = new JLabel("(Your 16-digit Card number)");
        l5.setFont(new Font("Raleway", Font.BOLD, 12));

        l6 = new JLabel("Your SDU card will display a number");
        l6.setFont(new Font("Raleway", Font.BOLD, 12));

        l7 = new JLabel("PIN:");
        l7.setFont(new Font("Raleway", Font.BOLD, 18));

        l8 = new JLabel("XXXX");
        l8.setFont(new Font("Raleway", Font.BOLD, 18));

        l9 = new JLabel("(4-digit password)");
        l9.setFont(new Font("Raleway", Font.BOLD, 12));

        l11 = new JLabel("Form No:");
        l11.setFont(new Font("Raleway", Font.BOLD, 14));


        b = new JButton("Submit");
        b.setFont(new Font("Raleway", Font.BOLD, 14));
        b.setBackground(Color.BLACK);
        b.setForeground(Color.WHITE);







        r1 = new JRadioButton("SDU scholarship");
        r1.setFont(new Font("Raleway", Font.BOLD, 16));
        r1.setBackground(Color.WHITE);

        r2 = new JRadioButton("Scholarships from companies");
        r2.setFont(new Font("Raleway", Font.BOLD, 16));
        r2.setBackground(Color.WHITE);

        r3 = new JRadioButton("International scholarship");
        r3.setFont(new Font("Raleway", Font.BOLD, 16));
        r3.setBackground(Color.WHITE);

        r4 = new JRadioButton("No scholarship");
        r4.setFont(new Font("Raleway", Font.BOLD, 16));
        r4.setBackground(Color.WHITE);

        t1 = new JTextField();
        t1.setFont(new Font("Raleway", Font.BOLD, 12));





        setLayout(null);

        l11.setBounds(700,10,70,30);
        add(l11);

        t1.setBounds(770,10,40,30);
        add(t1);

        l1.setBounds(280,50,400,40);
        add(l1);

        l2.setBounds(100,140,200,30);
        add(l2);

        r1.setBounds(100,180,150,30);
        add(r1);

        r2.setBounds(350,180,300,30);
        add(r2);

        r3.setBounds(100,220,250,30);
        add(r3);

        r4.setBounds(350,220,250,30);
        add(r4);

        l3.setBounds(100,300,200,30);
        add(l3);

        l4.setBounds(330,300,250,30);
        add(l4);

        l5.setBounds(100,330,200,20);
        add(l5);

        l6.setBounds(330,330,500,20);
        add(l6);

        l7.setBounds(100,370,200,30);
        add(l7);

        l8.setBounds(330,370,200,30);
        add(l8);

        l9.setBounds(100,400,200,20);
        add(l9);
        b.setBounds(570,600,100,30);
        add(b);

        b.addActionListener(this);






        Color  colors   = new Color(51, 153, 255);
        getContentPane().setBackground(colors);

        setSize(850,850);
        setLocation(500,90);
        setVisible(true);



    }

    public void actionPerformed(ActionEvent ae){


        String a = null;
        if(r1.isSelected()){
            a = "Saving Account";
        }
        else if(r2.isSelected()){
            a = "Fixed Deposit Account";
        }
        else if(r3.isSelected()){
            a = "Current Account";
        }else if(r4.isSelected()){
            a = "Recurring Deposit Account";
        }

        Random ran = new Random();
        long first7 = (ran.nextLong() % 90000000L) + 5040936000000000L;
        long first8 = Math.abs(first7);

        long first3 = (ran.nextLong() % 9000L) + 1000L;
        long first4 = Math.abs(first3);

        String b = "";


        String c = t1.getText();






    }

    public static void main(String[] args){
        new Signup3().setVisible(true);
    }

}

