import sys
from socket import *
import time

#create socket
s = socket(AF_INET,SOCK_DGRAM)
#set timeout as 1 second
s.settimeout(1)
#giving address and port number for connection
addr = (sys.argv[1],int(sys.argv[2]))
#send 10 ping messages
for n in range(10):
    #?
    t1= time.asctime( time.localtime(time.time()) )
    t2 = time.time()
    m = n+1
    #send message
    message = "ping"+" "+str(m)+" "+str(t1)
    #?
    s.sendto(message,addr)

    try:
        #?
        data,server = s.recvfrom(1024)
        t3 = time.time()
        rtt = t3 - t2
        print(data)
        print("Round Total Time", rtt)
    #no message sent back from server in 1 second, 
    #time out and treat it as message lost
    except timeout:
        print("Request time out")