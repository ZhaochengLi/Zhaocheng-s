## Taking Wireshark for a Test Run

Read the **Wireshark_HTTP_v7.0.pdf** if you need additional help.

  * Start `CSC361-VM`.
  * Start Wireshark with __Capture Filter__ set to `host web.uvic.ca`.
  * Start capture packets from `eth0` (whichever is your default network interface).
  * Open Firefox (or any browser) and clear all its histories and content data.
  * Enter the URL <http://web.uvic.ca/~mcheng/lab1/csc100.html>.
  * After the page loaded, do it again using "reload".
  * Now, you can stop capturing packets in Wireshark but don't close it.
  * After you have completed all the answers, save the Wireshark session into a `.pcap` file.
  * Close Firefox and Wireshark. You are done!

## Questions
Answer the following questions in the space provided. Submit your answers (a modified version of this file) as an attachment to the submission box. (**Note**: You don't need to attach your saved `.pcap` file. But we may ask you to show it in the lab.)

*Nothice: The solutions are done on own laptop using vritual-box*
  
  1. What is the **source IP address** of the HTTP request?
  
  -`It is 10.0.2.15, which is the IP address of host.`
  
  2. What is the **destination IP address** of the HTTP response?
  
  -`It is also 10.0.2.15, since the the host is the destination to which the HTTP response messages are sent`

  3. What is the **length** of the HTTP response body text in bytes (just the `csc100.html` file, not including all other images)?
  
  -`The Content length of the HTTP response to HTTP GET message for csc100.html is 3182 bytes`

  4. Which **versions** of HTTP protocol are running on the client and on the server?
  
  -`Both are running HTTP/1.1`

  5. What is the **HTTP status code** returned by the server?
  
  -`200 for the first load, and 304 indicating 'NOT MODIFIED' after reloading`

  6. When is the **last-modified date** of the requested file `csc100.html`?
  
  -`Wed, 15 Aug 2018 23:38:03 GMT\r\n`

  7. Did you find the HTTP request with `If-Modified-Since:`? What is the packet number? (**Note**: If not, try reload the page.)
  
  -`Found them. The packet numbers are 241, 247, 249, 254. Those packets are used for loading csc100.html and pictures after reloading respectively`

  8. Did you see the response status code `304 Not Modified`? What is the packet number? (**Note**: If not, try reload the page.)
  
  -`Found them, they are 245, 252, 255, and 260`

  9. In total, how many HTTP GET requests were sent in order to download the whole of `csc100.html` file, including all images?
  
  -`With reloading process being excluded, the total number of HTTP GET requests sent are 5`

  10. What is the TCP port number used by your browser to download the whole of `csc100.html` file, including all images?
  
  -`http (80)`

  11. Did you find the HTTP request with `If-Modified-Since:`? What is the packet number? (**Note**: If not, try reload the page.)
  
  -`I have re-open the browser and load the page with the cache left. the packet numbers are: 11, 15, 21, 27`

  12. Did you see the response status code `304 Not Modified`? What is the packet number? (**Note**: Try reload the page.)
  
  -`Yes, the packet numbers are 13, 19, 22, 23`
