import sys
import socket as so

HOST=''
PORT=2000
#Step 1:create socket
try:
    s=so.socket(so.AF_INET,so.SOCK_STREAM)
except so.error, msg:
    print("Failed to create socket. ERROR CODE: ",msg[0]," ERROR MESSAGE: ", msg[1])
    sys.exit()
print("Step 1: Socket Created.")
#Step 2:bind
try:
    s.bind((HOST,PORT))
except so.error, msg:
    print("Failed to bind. Error Code: ",msg[0]," Error Message: ",msg[1])
    sys.exit()
print("Step 2: Socket Bind Completed.")
#Step 3: listen and connect
#listen
s.listen(20)
print("Server Socket is Now Listening ... ...")
#loop
while True:
    #wait
    print("block...")
    conn, addr = s.accept()
    print("pass...")
    print("COnnected with: ",addr)
    #communicate
    data=conn.recv(2000) #receive
    reply='Client just said: '+data
    conn.sendall(reply) #send
    #close
    conn.close()
s.close()
