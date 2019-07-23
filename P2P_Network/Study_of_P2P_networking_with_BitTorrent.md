Summary of P2P Networking with BitTorrent
===
- Original paper from *Jahn Arne Johnsen*, *Lars Erik Karlsen*, and *Sebjorn Saether Birkeland*,Department of Telematics. NTNU, December 2005
- Thank you

---
Abstract
===
P2P, Peer-to-peer networking, has now received a lot of attention in music and movie industries. But it is NOT a new technology, we will briefly introduce its history later.

BitTorrent, on the other hand, is a *distributed peer-to-peer* system, which has the potential to *change the landscape broadcast media and file distribution.*

---
### How BitTorrent Works briefly?
It uses a symmetric (tit-for-tat) tranferring model in an attempt to reach Pareto efficiency.

Its protocol employes various mechanisms and algorithms in a continuous effort to try to ensure that there are no other variations in the network arrangement which will make every downloader ar least as well off and at least one downloader strictly better off.

---
In its original implementation, BitTorrent bases its operations around the concept of a *Torrent* file, a *centralized tracker* and an associated swarm of peers. The centralized tracker provides the different entities with an address list over available peers. 

Later improvements tries to eave the weakness of a single point of failure(the tracker), by implementing a new *distributed tracker solution*.

This technology will no doubt have a bright future of applications, we will talk more about it.

---
Introduction
===
This has been a trend to use P2P solutions into current softwares.

Compared to its opposite, the traditional *server-client* solution, the P2P approach has advantages.

- increased robustness and resource providing, such as bandwidth, storage, and computing power, by peers.
- one area where robustness and utilization of resources are important is **file distribution**, especially for large files.
- BitTorrent is proven example that the P2P solutions are more efficient and reliable than the traditional server-client solution.

---
Do not forget, the paper is talking about P2P, and BitTorrent as well. 

We will focus on the BitTorrent as a P2P solution and explain the architecture and concepts that make up BitTorrent. Its past and future prospective will be also presented and discussed as well.

---
P2P Networking Architecture
===
> "The emergence of peer-to-peer computing signifies a revolution in connectivity that will be profound to the Internet of the future as Mosaic was to the Web of the past"

A simple definition of P2P networking:
> A communications model in which each party has the same capabilities and either party can initiate a communication session.

Therefore, conceptually, P2P computing has become a alternative ro the traditional server-client architecture, where typically is a single (or small cluster) server and many clients.

---
The Domain Name System (DNS) is a good example of a blend between the traditional peer-to-peer networking and a hierarchical model of *information ownership*.

THe more precise definition is stated:
>"A distributed network architecture may be called a Peer-to-Peer (P2P) network, if the participants share a part of their own (hardware) resources (processing power, storage capacity, network link capacity, printers, ...). These shared resources are necessary to provide the Service and content offered by the network (file sharing or shaied workspaces for collaboration). They are accessible by other peers directly, without passing intermediary entities. The participants of such a network are thus resource (Service and content) providers as well as resources (Service and content) requestors (Servant-concept)."

---
As there exists many forms of peer-to-peer networks, both with and without some with a form of central entity. 

Therefore, the difinition above was further refined, and we can introduce a classification of P2P networks as either ***pure*** or ***hybrid***, based on whether they work with/without the central entity.

---
### Pure P2P
It is a network in which the peers themselves are the only entities allowed within. Or
> "A distributed network architecture has to be classified as a "Pure" P2P network, if it is firstly a P2P network according to definition 1 and secondly if any single, arbitrary chosen Terminal Entity can be removed from the network without having the network suffering any loss of network service."

This system is able to avoid having any fatal consequences on the network, i.e., there is no single point of failure.

---
### Hybrid P2P
A hybrid network will always include some sort of central entity.
> "A distributed network architecture has to be classified as a "Hybrid" P2P network, if it is firstly a P2P network by definition, and secondly a central entity is necessary to provide parts of offered network services."

This makes the Hybrid P2P nerwork more vulnerable to attacks or failure.

---
Introduction to BitTorrent
===
### BitTorrent is a technology/protocol which makes the distribution of files, especially large files, easier and less bandwidth consuming for the publisher.

And this is accomplished by **utilizing the upload capaciyu of the peers that are downloading a file. A considerably increase in downloaders will only result in a modest increase in the load on the publisher hosting the file.**

---
Suppose we use slient-server approach to download. The peers download from the server simultaneous. If we assume the upload capacity of the server is the same as the download capacity of a peer, the time for the download to finish will be two times the time if only one peer where downloading from the server. ***By splitting the file and send one part to each peer, and let the peers download the part they are missing from each other, both download time and load on the server are reduced.***

---
### Areas of Usage
- Piracy and illegal distribution is the first thing to mind when you hear about P2P file sharing.
- But the BitTorrent protocol has features which makes it usable for totally legitimate purposes.
- Due to the increased download speed, it has the benefit that it eases the pressure on the servers when a new version is published.
- BitTorrent is best suited for new, popular files which many people have interest in.It is easy for a user to find different parts of the files and download them quickly. This is can be called the *multiplier effect*, and a lightly popular show or movie can become insanely popular within days, or maybe within hours. Old or unpopular files will be difficult to find and there will be few users to download from. This makes the protocol effective when dealing with highly demanded files, and absecure files tend not to be available.