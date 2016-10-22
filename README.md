Objective-C WithOut Operational Transform (WOOT) Implementation
===================
![WOOT demo](https://raw.githubusercontent.com/ansonl/objc-woot/master/woot-demo.gif)

A working Objective-C implementation of the collaborative editing algorithm WithOut Operational Transform (WOOT). 

WOOT is a framework that ensures intention consistency between multiple users' edits. Similar to collaborative editing without a central server.

Credits to G ́erald Oster, Pascal Urso, Pascal Molli, Abdessamad Imine. Real time group editors with- out Operational transformation. [Research Report] RR-5580, INRIA. 2005, pp.24. <inria- 00071240>])
[WOOT research paper link](https://hal.inria.fr/inria-00071240/document)

Use it now
-------------
![Mesh Notes iOS icon](https://raw.githubusercontent.com/ansonl/objc-woot/master/mesh-notes-icon.png)
I used this implementation in [Mesh Notes](https://itunes.apple.com/us/app/mesh-notes-internetless-collaboration/id1160071680?mt=8), a free iOS app that allows nearby users to collaborate on notes. 

↓ Usage
===================

 - Download, open Xcode project, and run.
	 - The `MainViewController` contains two `UITextViews` that receive each other's edit operations and process them.
	 
Notes
-------------
 - This code was mostly copied from the finished version of [Mesh Notes](https://itunes.apple.com/us/app/mesh-notes-internetless-collaboration/id1160071680?mt=8), my iOS app that uses this implementation of WOOT. 
 - The UITextView delegate methods are implemented in the `WOOTTextViewDelegate` class. 
   - Cut, Copy, Paste operations are broken down into individual insert and delete operations. 
   - The project deployment target is set to iOS 9 because iOS 8 sends a different set of `NSRanges` to `UITextViewDelegate`.
 - `WString` class contains most of the WOOT logic. 
 - `WCharacter+LocalPosition` and `WCharacter+Special` are not actively needed to make the algorithm function. All references to them may be removed if desired. 
 - You are free to modify and use the code in your projects.

License
-------------
Objective-C WithOut Operational Transform is made available under MIT License. 