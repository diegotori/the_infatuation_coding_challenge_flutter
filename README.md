# The Infatuation Coding Challenge (Flutter Edition)

Enables one to search GitHub Repositories and add them to a list of favorites sent through a Docker based endpoint.

Use the Search Bar on the top to search for GitHub Repositories and select one from the resulting Suggestions List in order to add it to your favorites.
The Favorited Repos should appear below the Search Bar.

Swipe left and tap `Delete` to remove the favorited repo. You can also `Pull-to-Refresh` the Favorites List in order to refresh the current data.

Finally, toggle the PlatformSwitch to the right of the Search Bar in order to sort favorited repos by stargazer count.


## Installation

* Install the [Flutter SDK](https://flutter.dev/docs/get-started/install) for your specific platform.
* Optionally install either [Android Studio](https://developer.android.com/studio/) or 
  [Visual Studio Code](https://code.visualstudio.com/).
* In the project's root directory, run the app by typing:
  
  ```bash
  flutter run -t lib/main.dart
  ```
  You may get prompted to select a device to run the app with.
  
  Or from within Android Studio/Visual Studio Code, Create a Run Configuration that runs `lib/main.dart`.
  
  In Android Studio, select the device you want run the app on from the dropdown to the left of the Run Configuration dropdown.
  
* Run tests by typing:

  ```bash
  flutter test
  ```
