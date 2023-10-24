# PS Dispatch

Integrated with [ps-mdt](https://github.com/Project-Sloth/ps-mdt)

For all support questions, ask in our [Discord](https://www.discord.gg/projectsloth) support chat. 
Do not create issues on GitHub if you need help. Issues are for bug reporting and new features only.

# Depedency
1. [qb-core](https://github.com/qbcore-framework/qb-core)
2. [ox_lib](https://github.com/overextended/ox_lib)
3. [ps-mdt](https://github.com/Project-Sloth/ps-mdt) - Optional but highly recommended.

# Installation
* Download ZIP
* Make sure your [qb-core}(https://github.com/qbcore-framework/qb-core) is fully updated to the latest version.
* Drag and drop resource into your server files
* Start resource through server.cfg
* Drag and drop sounds folder into interact-sound\client\html\sounds
* Configure your [language](https://github.com/Project-Sloth/ps-dispatch#change-language)
* Restart your server.

# Preview
<img src="https://github.com/Project-Sloth/ps-dispatch/assets/82112471/4a3d44b9-1629-457b-ba0e-a77c617aa993" width="600">
<img src="https://github.com/Project-Sloth/ps-dispatch/assets/82112471/7f4a7c76-f92d-4067-9fcb-7c78ee1b067c" width="600">
<img src="https://github.com/Project-Sloth/ps-dispatch/assets/82112471/01569df8-d5f6-417b-bcd4-422551eaa840" width="600">
<img src="https://github.com/Project-Sloth/ps-dispatch/assets/82112471/f2b111b2-60c3-428e-b12a-1bfed617f09e" width="800">

# Change Language.

- Place this `setr ox:locale en` inside your `server.cfg`
- Change the `en` to your desired language!
  
**Supported Languages:**
| **Alias**     | **Language Names** |
|--------------|---------------|
|en      |English    |
|de      |German     |
|nl      |Dutch      |
|cs      |Czech      |
|pt-br      |Brazilian Portuguese      |
|es      |Spanish      |

# Preset Alert Exports.

```lua
- exports['ps-dispatch']:VehicleShooting(vehicle)

- exports['ps-dispatch']:Shooting()

- exports['ps-dispatch']:OfficerDown()

- exports['ps-dispatch']:SpeedingVehicle(vehicle)

- exports['ps-dispatch']:Fight()

- exports['ps-dispatch']:InjuriedPerson()

- exports['ps-dispatch']:DeceasedPerson()

- exports['ps-dispatch']:StoreRobbery(camId)

- exports['ps-dispatch']:FleecaBankRobbery(camId)

- exports['ps-dispatch']:PaletoBankRobbery(camId)

- exports['ps-dispatch']:PacificBankRobbery(camId)

- exports['ps-dispatch']:PrisonBreak()

- exports['ps-dispatch']:VangelicoRobbery(camId)

- exports['ps-dispatch']:HouseRobbery()

- exports['ps-dispatch']:DrugSale()

- exports['ps-dispatch']:ArtGalleryRobbery()

- exports['ps-dispatch']:HumaneRobery()

- exports['ps-dispatch']:TrainRobbery()

- exports['ps-dispatch']:VanRobbery()

- exports['ps-dispatch']:UndergroundRobbery()

- exports['ps-dispatch']:DrugBoatRobbery()

- exports['ps-dispatch']:UnionRobbery()

- exports['ps-dispatch']:YachtHeist()

- exports['ps-dispatch']:CarBoosting(vehicle)

- exports['ps-dispatch']:CarJacking(vehicle)

- exports['ps-dispatch']:VehicleTheft(vehicle)

- exports['ps-dispatch']:SuspiciousActivity()

- exports['ps-dispatch']:SignRobbery()
```
# FAQ
* There are no calls showing on dispatch or mdt list.
  - Make sure you have a job type specified in your qbcore/shared/jobs.lua like:
  
    ![image](https://github.com/Project-Sloth/ps-dispatch/assets/9503151/7834e878-5020-4fcc-8864-03d44120c160)

  - Make sure that you're using the correct job type as leo and make sure your [qb-core](https://github.com/qbcore-framework/qb-core) is fully updated to the latest version.
  - On shared/config.lua make set Config.Debug = true to test calls as police officer.(ONLY to be used as testing, make sure to disable on live production)

# Credits
* [OK1ez](https://github.com/OK1ez)
* [Candrex](https://github.com/CandrexDev)
* [Lenzh](https://github.com/Lenzh)
* [LeSiiN](https://github.com/LeSiiN)
* Project Sloth Team
