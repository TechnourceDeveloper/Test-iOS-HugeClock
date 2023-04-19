# HugeClock
Specializing in time-related software

## Getting Started

## Features
- [x] Users are able to set a reminder/alarm for a particular time of the day.
- [x] Any app setting changed by the user that saved automatically
- [x] The users are able to disable or re-enable reminders/alarms
- [x] The users are able to delete reminders/alarms

## Requirements

- iOS 14.2+
- Xcode - 14.2+
- Swift - 5+

****Steps after project clone successfully.****

1. Set deployment target 
2. Manage certificates
3. After these steps run project.

**About Project files:**  
##### Folder Structure  
Here is the core folder structure which iOS provides. iOS-app/  

    |- HugeClock  
    |- ViewControllers  
    |- Data
    |- Utilities 
    |- AppDelegate
    |- SceneDelegate
    |- Main Stroryboard
    |- Assets
    |- LaunchScreen Stroryboard
    |- Info
    |- Reminders.xcdatamodeld

#### Manually
1. CoreData

## Usage example

```swift
import CoreData
static  func  saveData(onContext context: NSManagedObjectContext!){
    do {
        try context!.save()
    } catch {
        print("Failed saving")
    }
}
```

## Meta

Your Name – Technource Developer
[https://github.com/TechnourceDeveloper/Test-iOS-HugeClock](https://github.com/dbader/)
