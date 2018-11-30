from socket import *

msg = "\r\n I love computer networks!"
endmsg = "\r\n.\r\n"

# Choose a mail server (e.g. Google mail server) and call it mailserver
mailserver = ?????????

# Create socket called clientSocket and establish a TCP connection with mailserver
???????

recv = clientSocket.recv(1024).decode()
print(recv)
if recv[:3] != '220':
	print('220 reply not received from server.')

# Send HELO command and print server response.
heloCommand = 'HELO Alice\r\n'
clientSocket.send(heloCommand.encode())
recv1 = clientSocket.recv(1024).decode()
print(recv1)
if recv1[:3] != '250':
    print('250 reply not received from server.')
    
# Send MAIL FROM command and print server response.
??????

# Send RCPT TO command and print server response. 
??????


# Send DATA command and print server response. 
??????

# Send message data.
??????

# Message ends with a single period.
???????

# Send QUIT command and get server response.
???????