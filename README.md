# sp-jailbreak
This is a refactored version of the plugin [organharvester](https://github.com/destoer), Jordi, and I worked on over the past year or so. This version is slightly more modular, and should allow for easier changes as the components have been spread out.

## Commands
```
!w                  Become Warden
!uw                 Leave Warden
!rw                 Remove Warden   (Admin)
!wb                 Enable block
!wub                Enable noblock
!block              Enable block    (Admin)
!ublock             Enable noblock  (Admin)
!laser              Show laser menu
!marker             Show marker menu
!warday <location>  Call warday
!awarday <location> Call warday (Admin)
!cwarday            Cancel warday
```

## Forwards
```sp
/**
* Called when a client becomes Warden.
* @param    client  Client index
*/
forward void Jailbreak_OnWardenBecome(int client);

/**
* Called when a client is no longer the Warden. Make sure you verify
* that the client is still valid.
* @param    client  Client index
*/
forward void Jailbreak_OnWardenRemove(int client);
```

## Natives
```sp
/**
* Get the ID of the Warden
* @return   ClientID of the Warden
*/
native int GetWardenID();

/**
* Remove the Warden
* @return   none
*/
native any RemoveWarden();

/**
* Re-enable the ability to become Warden
* @return   none
*/
native any EnableWarden();

/**
* Disable the ability to become Warden and remove the current Warden
* @return   none
*/
native any DisableWarden();

/**
* Enables the Warden text to show on the hud
* @return   none
*/
native any EnableWardenHud();

/**
* Disable the Warden text from showing on the hud
* @return   none
*/
native any DisableWardenHud();
```

## Licensing
As with all SourceMod plugins, this code is licensed under GPL-3.0.

## Dependencies
* [SetCollisionGroup](https://github.com/ashort96/SetCollisionGroup)