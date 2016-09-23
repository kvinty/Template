## About
This is a minimalistic Android project template. The final APK weights 8.3 KiB, whereas a basic empty project created in Android Studio consists of hundreds of files and results in a 1.4MiB APK. It is based on a [Habrahabr article](https://habrahabr.ru/post/309504), all the details are described there, but this project might be more convenient to use on GNU/Linux.

## How to use
* Install [Java Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* Install [Android Software Development Kit](https://developer.android.com/studio/index.html)
* Open Makefile and set the variables accordingly to your settings
* Connect an Android device or emulator
* Run `make`

## May this structure be used in a real-world project?
Of course, it is more convenient to develop using Android Studio. But if the project is already written, and you want to save some mebibytes on user's devices, removing useless source files may be an easy way to make your program a bit less bloated.
