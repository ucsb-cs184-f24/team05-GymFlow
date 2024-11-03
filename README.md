# HOW TO BUILD

1. Clone

```
git@github.com:ucsb-cs184-f24/team05-GymFlow.git
```

2. Change to this branch

```
cd team05-GymFlow
git checkout -b prod-andy-tommy origin/prod-andy-tommy
```

3. Open Xcode

```
xed .
```
4. Get Google plist credentials on Slack, then replace the one in PhoneAuth in Xcode

   Make sure to delete the original one. Only the one from Slack should exist.

5. Make sure build target is for iPhone simulator
6. Add API key
   - Make account [here](https://besttime.app/)
   - Use public API key on line 6 PhoneAuth/Controllers/BusyLevelView.swift

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
