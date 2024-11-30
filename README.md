# HOW TO BUILD

1. Clone

```
git@github.com:ucsb-cs184-f24/team05-GymFlow.git
```

2. Make sure on main branch

```
git branch
```

3. Open Xcode (Make sure Version >= 16.1)

```
xed .
``` 

4. Get Google plist credentials on Slack, then replace the one in PhoneAuth in Xcode

   Make sure to delete the original one. Only the one from Slack should exist. (Drag the file into Xcode to replace)
   [LINK TO SLACK](https://ucsb-cs184-f24.slack.com/files/U07PH3AMD1S/F07TNUEDCFQ/googleservice-info.plist)

5. Get GeminiAPI plist on Slack. Drag into PhoneAuth.
   [LINK TO SLACK](https://ucsb-cs184-f24.slack.com/files/U07PC0X8SLV/F082U5B6AGZ/geminiapi.plist)
6. Get UCSB API on slack. Drag into PhoneAuth
    [LINK TO SLACK](https://ucsb-cs184-f24.slack.com/files/U07PDMYDJBY/F082W4NELFQ/ucsb.plist)
7. Make sure build target is for iPhone simulator (>= 18.0), then press play to run

# team05-GymFlow

Our project looks to monitor activity at the UCSB Recreation Center so that students can gauge how busy the gym is.

In gymflow, the interface will provide users with a graphic of how busy the UCSB Recreation Center is. Users will have to sign up using their phone number and authentication will be provided as well. The app will be built using Swift and will only be available on IOS platforms. We plan for this app to help gym-goers plan their workouts more efficiently. There is one user role in this app which is users who want to know how busy the gym is.

- Tech Stack: Swift, IOS
- Github IDs
  * NevMan1 , Nevin Manimaran
  * brycewangg , Bryce Wang
  * winstonwangUCSB , Winston Wang
  * dhwang154 , Daniel Hwang
  * andyjin1 , Andy Jin
  * Tommygithubaccount123 , Thomas So
