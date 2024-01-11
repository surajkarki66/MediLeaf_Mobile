# MediLeaf
This is the mobile application that uses both the APIs from [MediLeaf_backend](https://github.com/surajkarki66/MediLeaf_backend) and [MediLeaf_AI](https://github.com/surajkarki66/MediLeaf_AI) to serve its purpose, which is to predict the species of the plant and its properties and significance using the plant's leaf image. MediLeaf is an application whose motive is to help the individual identify medicinal plants with their properties by just scanning the leaf of any plant, which might result in creating curiosity about plants that leads to the preservation of valuable plants.

## Steps to run the app locally
1. Run the `MediLeaf AI Model Server` by following the instructions given here: https://github.com/surajkarki66/MediLeaf_AI
2. Run the `MediLeaf Knowledge Base Server` by following the instructions given here: https://github.com/surajkarki66/MediLeaf_backend
3. After running both the servers, either Launch an Android Studio and open Android Emulator or connect a USB debugging-enabled Android phone to your local machine using a USB data cable.
- If you use the Android Emulator, you have to go to the `config.dart` which is inside the `lib/config/`, paste the code snippet below after removing the existing code.
```dart
String kbBaseUrl = "http://10.0.2.2:8000";
String aiBaseUrl = "http://10.0.2.2:8080";
```
- If you connect a USB debugging-enabled Android phone to your local machine using a USB data cable instead of using android emulator, you have to first run the following commands inside the terminal.

```bash
   adb reverse tcp:8000 tcp:8000;adb reverse tcp:8080 tcp:8080
```
4. Run the command
```bash
$ flutter run
```

Happy Coding!!
