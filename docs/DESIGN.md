# Initial Figma Design

<img width="904" alt="image" src="https://github.com/user-attachments/assets/84d2e28a-54fb-435c-a833-4b5fa9e5146f">

[Figma](https://www.figma.com/design/h0vVzSqlSK0Hm4goIJbUmJ/gymflow-design?node-id=0-1&m=dev&t=Klr2piWTCvKuq9LC-1)

Our app homescreen contains a forecast and live busy level of the UCSB Recreational Center. Pressing the refresh updates the live busy level.
The settings screen contains general settings and the option to log out. The barcode screen is for a user to take a picture of their 
access card and store it on the app. This allows the user to show the app to scan into the rec center.

Team meetings:
- [Section notes](https://github.com/ucsb-cs184-f24/team05-GymFlow/blob/main/team/sprint04/sect06.md)
- [Backlog notes](https://github.com/ucsb-cs184-f24/team05-GymFlow/blob/main/team/PRODUCT_BACKLOG.md)

We agreed to display a forecast of the gym busy level. We also agreed to have an access card implementation to save the barcode on the app.

We considered keeping the app simple with tabs and screens. We allowed each screen to be accessible.

# Initial Implementation

<img width="350" alt="Screenshot 2024-11-21 at 10 03 46 PM" src="https://github.com/user-attachments/assets/7a7b00bf-708b-4710-9a69-4b45cc5acb04">

<img width="344" alt="Screenshot 2024-11-21 at 9 56 26 PM" src="https://github.com/user-attachments/assets/3374b782-39e3-447f-9583-d37117a4b4a5">

<img width="349" alt="Screenshot 2024-11-21 at 10 01 26 PM" src="https://github.com/user-attachments/assets/c44e96d2-d21f-4cc5-ba0a-a32ea14cb408">

Our initial implementation of the features. Continued with tab and separate screen logic. Chose Besttimes API service for querying gym busy level. Chose Firebase Auth for user log in. [Notes](https://github.com/ucsb-cs184-f24/team05-GymFlow/blob/main/team/sprint03/lect07.md) 

# Final Implementation

<img width="350" src="https://github.com/user-attachments/assets/538221f2-b393-486e-bb24-de720e2f9c77">

<img width="350" src="https://github.com/user-attachments/assets/5a1eef71-6f35-41d8-b771-5a8de109d141">

<img width="350" src="https://github.com/user-attachments/assets/7c2e464c-0548-4d86-a90a-045c84c91853">

<img width="350" src="https://github.com/user-attachments/assets/4fc84548-92b9-4273-8df5-5ec23e7767f3">

<img width="350" src="https://github.com/user-attachments/assets/197e813e-f408-4211-ba5a-fa60a5d72a0f">

<img width="350" src="https://github.com/user-attachments/assets/15af5185-4143-466a-b642-71fad9b242a0">

Team agreed to combine some features to one tab. App UI was redesigned and more features were added ([Notes](https://github.com/ucsb-cs184-f24/team05-GymFlow/blob/main/team/sprint04/lect16.md)). Kanban board includes stories for our progress. Other features were also improved via UI and back-end logic. Google Gemini and UCSB API services were used for the new features.

# Difficulties
Team ran into a large amount of struggle with Xcode development, since team had no previous experience with Xcode/Swift dev. Difficulties included Xcode/Swift project file system learning, Swift language, git tracking, merge conflicts, Xcode build issues, and physical phone development permissions issues. Team members with weaker hardware suffered from very long build and installing times.
