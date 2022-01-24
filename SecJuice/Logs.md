***Logs, Logs, and 4jLogs? Thankfully, no.***

I recently came across a tool that satisfied a blue team itch. Equipped with log aggregation, dashboard management, analyzer and monitoring tool.
One of the strongest gauges of curiosity is to learn more about my local network.
My curiosity flows to what I'm associated with or is accompanying me. 
I was searching for an all-in-one setup in order to aggregate logs and gain more insight of what's traversing my network.
Google, threw some great results, such as OSSEC, ELK Stack, and Apache Metron. I wasn't too sure what tool I wanted to use, I usually base my decision
off of the amount of stars on github and reviews I've found online, and of course, it's gotta be open source. Strong indicators of likable tools include the following:

##    1) Easy set-up, because I don't enjoy compiling programs.
##    2) Easibility, because I'm lazy.
##    3) Functionality, because we want all the features.
##    4) [Community](https://wazuh.com/community/), continuous improvement and flexability is gre


##Setup::##
I decided on [Wazuh](https://github.com/wazuh/wazuh) with 3.2k stars and 682 forks, from word of month and the fact it was a fork of [OSSEC HIDS](https://github.com/ossec).
There is an .ova file in order that allows for an all-in-one server with elastic stack.
to run the VM setup as a wazuh-manager (server), which also gives the easebility of adding wazuh-users (clients).
The set-up the server in very few steps and then threw an agent onto my bare-metal windows box and nother ubuntu 20.04 virtualmachine
I had lying around. 

##Ease of Use##
compliance and it's importance
screenshots of use
log aggregation
cross platform - Linux/Windows/Macos

##Functionality##
orchestration
containers


##Community::##
Wazuh has a huge [community](https://wazuh.com/community/) with lots of ways to connect, with slack, Google Groups and of course github 

TODO: intertwine Log4J into the topic
    + Logging Log4J on Wazuh
    + screen shots of application and compliance

