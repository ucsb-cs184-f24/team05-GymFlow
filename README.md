# HOW TO BUILD

1. Clone

```
git clone git@github.com:ucsb-cs184-f24/team05-GymFlow.git
cd team05-GymFlow
```

2. Make sure on main branch

```
git branch
```

3. Run pod install
```
pod install
```

4. Open Xcode (Make sure Version >= 16.1)

```
xed .
``` 

5. Get Google plist credentials on Slack, then replace the one in PhoneAuth in Xcode

   Make sure to delete the original one. Only the one from Slack should exist. (Drag the file into Xcode to replace)
   [LINK TO SLACK](https://ucsb-cs184-f24.slack.com/files/U07PH3AMD1S/F07TNUEDCFQ/googleservice-info.plist)

6. Get GeminiAPI plist on Slack. Drag into PhoneAuth.
   [LINK TO SLACK](https://ucsb-cs184-f24.slack.com/archives/C07R095CQ2C/p1732586491382259)

8. Get UCSB plist on Slack. Drag into PhoneAuth.
   [LINK TO SLACK](https://ucsb-cs184-f24.slack.com/files/U07PDMYDJBY/F082W4NELFQ/ucsb.plist)

9. Make sure build target is for iPhone simulator (>= 18.0), then press play to run

10. If you want to deploy the application to your phone (instead of the Xcode simulator), go to Targets, then Info Tab, and at the bottom where you see "Push Notifications", press the trash bin icon to delete "Push Notifications". Sign into your Apple dev account and make yourself as the team in Signing & Capabilities. You might need to change bundle identifier to a different unique string. Do not allow notifications when it asks for permissions. Go to your phone's General settings -> VPN & Device Management -> Your dev account -> Allow. Make sure build target is your physically connected phone.

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
