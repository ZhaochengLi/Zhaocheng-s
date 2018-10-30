import socket as so  #for sockets
import sys  #for exit

#create
try:
    s = so.socket(so.AF_INET, so.SOCK_STREAM)
except so.error:
    print 'Failed to create socket'
    sys.exit()
print 'Socket Created'

host = 'www.google.com';
port = 80; 
try:
    remote_ip = socket.gethostbyname( host )

except so.gaierror:
    #could not resolve
    print 'Hostname could not be resolved. Exiting'
    sys.exit()
#Connect to remote server
s.connect((remote_ip , port))
print 'Socket Connected to ' + host + ' on ip ' + remote_ip
#Send some data to remote server
message = "GET / HTTP/1.1\r\n\r\n"
try :
    #Set the whole string
    s.sendall(message)
except so.error:
    #Send failed
    print 'Send failed'
    sys.exit()
print 'Message send successfully'
#Now receive data
reply = so.recv(4096)
print reply
so.close()
