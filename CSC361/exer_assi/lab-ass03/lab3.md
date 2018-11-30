# Lab 3 (SMTP)


## Problem Statement
By the end of this lab, you will have acquired a better understanding of SMTP protocol. You will also gain experience in implementing a standard protocol using Python.

Your task is to develop a simple mail client that sends email to any recipient. Your client will need to connect to a mail server, dialogue with the mail server using the SMTP protocol, and send an email message to the mail server. Python provides a module, called `smtplib`, which has built in methods to send mail using SMTP protocol. However, we will not be using this module in this lab, because it hide the details of SMTP and socket programming.

In order to limit spam, some mail servers do not accept TCP connection from arbitrary sources. For the experiment described below, you may want to try connecting to your university mail server (pop3.uvic.ca) You may also try making your connection both from your home and from your university campus.
Code

## SMTP
Start up `CSC361-VM1`, use `telnet` into `smtp.uvic.ca` with port `25`, send yourself a `hello it is me` email to any of your personal email account (e.g., uvic.ca, gmail, yahoo). Follow the instructions shown here. If you received an email in your personal email account, then you understand the text-based SMTP protocol is.

![](telnet-smtp.uvic.ca.png)



## Sample Code
In file `smtpclient.py` you will find the skeleton code for the client. You are to complete the skeleton code. The places where you need to fill in code are marked with ???????. Each place may require one or more lines of code.

In some cases, the receiving mail server might classify your e-mail as junk. Make sure you check the junk/spam folder when you look for the e-mail sent from your client.


## What to Hand in

In your submission, you are to provide the complete code for your SMTP mail client as well as a screenshot showing that you indeed receive the e-mail message.



## Evaluation
You must demonstrate your working code inside the `CSC361-VM` using Wireshark. You **must** capture all related packets, including ARP, TCP and SMTP.

You are also required answer a few questions related to this lab during evaluation.

Our evaluation scheme is:
- (50%) Correctness of Python code
- (20%) Wireshark demo
- (30%) Questions and Answers (at least 5 questions)
