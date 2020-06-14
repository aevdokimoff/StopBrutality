# StopBrutality – Don't let others act out the violence.

![screenshots](https://github.com/aevdokimoff/StopPoliceBrutality/blob/master/screens.png)

In today's world, violence is gaining momentum. Often people act violently against each other because of racism, chauvinism, bias etc. Sometimes, violence comes even from people who have our safety in their hands, such as the police. Together, however, we can confront this threat and build a democratic and tolerant world for all people.

## That is how we can do it
StopBrutality allows people to monitor each other's behavior and help others if necessary. For this purpose, there is a feed where people can post evidences of any incident and/or ask for help or warn others of a danger. A user needs to take a photo or a video of an incident and publish it in the app. After publication, any person will be able to see the post and respond to it in a timely manner. If a publication gathers enough reactions, it gets highlighted in the top, thus increasing the number of people who would pay attention to it. This can draw the public's attention to unacceptable incidents, such as police brutality, racism, xenophobia, chauvinism, discrimination etc.

### Functionality:
* Show act of violence cases (incidents) using heat map
* List incidents within a radius of 50 km 
* Add new incidents
* Take a photo or a video of an incident
* SOS button to call immediate help 
* Show the latest news 
* Save data decentralized to admin's servers
* Upvote/downvote posts

### Architecture:
![screenshots](https://github.com/aevdokimoff/StopBrutality/blob/master/architecture2.png)

The architecture of the data storage system is described as follows: all data that users upload to the application is stored decentralized. Specifically, all users of the application can be divided into two groups: ordinary users and administrators. The latter keep a copy of all data in an encrypted form on their computers acting as servers. Periodically, the data is being compared with other administrators to make sure that it is up to date. When launching the application, the user connects to one of the available (online) servers and requests data from there. The purpose of decentralization is to protect app's content and user's data from malevolent manipulation. To make sure that no unacceptable content is published in the application, posts with large numbers of downvotes are permanently deleted from the feed and from the admin's servers.

### In progress:
* Back-end part
* Comments section
* Remove mock data

## Tech Specifications:
* Programming language: Swift
* Alamofire
* Swifty
* LFHeatMap
* SPAlert
* PKHUD

## License
This project is available under the MIT license.
