## A share extension for quickly composing a text message to one person

I often send cute pictures or links to my wife over Messages.app, and the regular flow for this is ... not good:
1. Tap the "share" icon
2. Tap "Messages"
3. Begin to type her name
4. Tap the correct autocomplete entry (making sure to hit the exact right one)
5. Tap the (small) "send" button in the compose view that pops up.

This extension, once configured, lets you simplify this flow a lot:

1. Tap the "share" icon
2. Tap "share with bunny"
3. Tap the (still small) "send" button in the compose view - done.

That's almost all error-prone steps elimintated, making it much easier to share cute things.

### Words of caution

This is my very very first iOS program, and my very very first Swift program. I applied a lot of cargo cults. It's likely Not Very Good Programming. (Tests would help, for one!)

### Links that helped me

* Converting a SLComposeShareViewController to a custom UIViewController: https://github.com/atomicbird/iOS-Extension-Demo/commit/e95872ff45317e9877d98b3f2d2f629e46c99ba5
* The ShareAlike extension from ios8-day-by-day: https://github.com/shinobicontrols/iOS8-day-by-day/tree/master/02-sharing-extension/ShareAlike/ShareExtension
* emojione for the bunny icon: http://emojione.com/developers/
* How to pop up the message compose UI: https://www.appcoda.com/ios-programming-send-sms-text-message/
* Selecting contacts' coordinates from the address book: https://www.shinobicontrols.com/blog/ios9-day-by-day-day7-contacts-framework
* Extension scenarios: https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html