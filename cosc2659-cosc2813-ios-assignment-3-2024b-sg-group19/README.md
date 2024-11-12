# iOS FRIENDLY BOT 

<p align="center">
  <img width="250" src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/22/09/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19-main%202/Assignment3_SG-19/Assignment3_SG-19/Assets.xcassets/logo.imageset/logo%403x.png">
</p>


## 📖 Description

- This is a mental health chatbot app built using SwiftUI that integrates with OpenAI's ChatGPT API and utilizes Firebase for data storage, specifically designed to support people in Vietnam.
- The app allows users to engage in conversations aimed at improving their mental well-being, providing a safe space for reflection, guidance, and emotional support.
- Conversations are stored in Firebase and displayed in a scrollable view, enabling continuous dialogue where both the user’s thoughts and the assistant’s responses are remembered, fostering ongoing support throughout the user’s mental health journey.

  As Viktor Frankl, the renowned psychiatrist and Holocaust survivor, once said: “When we are no longer able to change a situation, we are challenged to change ourselves.” This app serves as a compassionate guide to help individuals take that step toward self-care and emotional resilience.user's and the assistant's messages are remembered.

<p align="center">
  <img src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/22/09/Sep-22-2024%2016-07-35.gif"height="600" > 
  <img src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/561d423c3bf3a63d24435c9ebabc01765738f4b0/Sep-22-2024%2016-01-16.gif" height="600" > 
    <img src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/22/09/Sep-22-2024%2016-15-39.gif" height="600" > 
  <img src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/22/09/Sep-22-2024%2016-15-46.gif" height="600" > 
  <img src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/22/09/Sep-22-2024%2016-21-51.gif" height="600" > 
  <img src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/22/09/Sep-22-2024%2016-22-23.gif" height="600" > 
   <img src="https://github.com/RMIT-Vietnam-Teaching/cosc2659-cosc2813-ios-assignment-3-2024b-sg-group19/blob/22/09/Sep-22-2024%2016-43-56.gif" height="600" > 
</p>


## ✨ Features
1.Create: 

- Users send a message to the chatbot.
  
- The chatbot stores the user's message in Firebase (or another database).
- The chatbot analyzes the text of the message and calculates a "mood score."
For example, positive words ("good," "happy") add +1 point, while negative words ("sad," "bad") subtract -1 point.
2. Read:
  
- The chatbot displays all previously stored messages from the database in chronological order.

- When a new message is received, the system automatically scrolls to the bottom to show the latest message.
3. Update:
  
- If the user edits a previously sent message, the chatbot updates the message in the database.
- The mood score is recalculated based on the new content of the message.
4. Delete:
  
- Users can delete messages they've sent.
- Once deleted, the message is removed from the database, and the mood score is updated if necessary.
  
5.Additional Features:
  
- Auto-scroll: When a new message arrives, the interface automatically scrolls to the latest message.
- Pin message to the top: Users can select important messages to be pinned at the top of the chat for easier management and follow-up.
- This feature outline can be included in the report for your chatbot project! Let me know if you'd like to integrate it into your GitHub repository.


## 🔧 Build Information
- Xcode 15.4
- SwiftUI Framework
- Target Deployment iOS >=17.5

## 🔮 Future Improvements
- **Message Persistence**: Implement Firebase Firestore or Realtime Database to save the conversation, so users can access past messages even after the app is closed.
- **Better Error Handling**: Add user-friendly UI components to manage common issues, such as invalid API keys, network connectivity problems, or API rate limits. Integrate Firebase Analytics to track errors.
- **Message Retry**: implement a "retry" button if the API call fails due to any error (e.g., network failure). Log retries and failures in Firebase for better debugging.
- **Enhance UI**: Add animations, improved visuals, and other user interface enhancements to make the experience more engaging. Utilize SwiftUI’s animation capabilities for better transitions between chat states.
## 🏆 Authors
- Nguyen Huy Anh - s3956092
- Tran Xuan Hoang Dat - s3651550
- Nguyen The Anh - s3927195
- Tran Vinh Trong - s3863973
