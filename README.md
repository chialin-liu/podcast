[DownLoad] (https://apps.apple.com/tw/app/%E8%81%BD%E8%81%BDlisten-podcast/id1514520783)
![image](https://github.com/chialin-liu/podcast/blob/master/podcast_screenShot/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202020-05-20%20at%2011.43.02.png "Search View")
![image](https://github.com/chialin-liu/podcast/blob/master/podcast_screenShot/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202020-05-20%20at%2011.43.18.png "Episode View")
![image](https://github.com/chialin-liu/podcast/blob/master/podcast_screenShot/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202020-05-20%20at%2011.43.37.png "Play View")
![image](https://github.com/chialin-liu/podcast/blob/master/podcast_screenShot/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202020-05-20%20at%2011.43.49.png "Favorites View")
![image](https://github.com/chialin-liu/podcast/blob/master/podcast_screenShot/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202020-05-20%20at%2011.44.04.png "Download View")
![image](https://github.com/chialin-liu/podcast/blob/master/podcast_screenShot/S__2465805.jpg "Lockscreen View")
![image](https://github.com/chialin-liu/podcast/blob/master/podcast_screenShot/S__2465807.jpg "Command Center")

## Application: 

I built the podcast that can search favorite podcast episodes and record favorite and download offline. Furthermore, I programmed using swift 5.1 ,xcode 11.3 using NiB, auto-layout and demo the app using iPhone 11.

## Demo
https://www.youtube.com/watch?v=8I8Qgjns0eI&t=1s

## Features
- [x] Search View
     - [x] Apply Alamofire framework to handle network operation when typing the texts in the searchBar
     - [x] Apply SDWebImage cache to speed up image load to reduce network loading
     
- [x] Episode View
     - [x] Add to favorite and show a "NEW" sign in the tabBar
     - [x] Apply FeedKit framework to process RSS format in the iTunes-API
     - [x] Apply SDWebImage cache to speed up image load to reduce network loading
     
- [x] Player View
     - [x] Add play/pause button
     - [x] Add forward/backward 15s
     - [x] Pull down the player view and add animation
     - [x] Pull up and maximize the player view
     - [x] Add player view when the iPhone locks the screen
     - [x] Add player view in the command center
     - [x] Adjust the sound slide and time-line slide
     - [x] Add next/previous episode play
     
- [x] Favorite View
     - [x] Collection view list of all the favorites
     - [x] Touch one of the favorite can show the episode view
     - [x] Can remove the favorite
     - [x] UserDefaults to store the favorites

- [x] Download View
     - [x] Use FileManager to store/delete the mp3 files in the local storage
     - [x] When downloading the mp3 file, if it is not ready, we can decide to play using internet
    
