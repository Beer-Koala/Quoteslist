# Quotelist

This app is result of technical assignment from TastyTrade, corresponds to the [code challenge description](2023-MobileEngineerCodeChallenge.pdf).

An application for tracking the prices of quotes, where quotes saved in watchlists.

The project done and meets the technical requirements. However, as there is no perfection, I also see some [improvements and enhancements](#improvements-and-enhancements) that could be added to the project.

### Features and Functionalities

- The project is set with a minimum supported iOS version of 16.0.
- Since there were no design requirements, the main reference was the Stock app by Apple.
- CocoaPods was used for third-party libraries.
- The Realms library was used for data storage.
- Swiftlint is also used in the project.

### Installation

The Pods folder is included in the repository, so it probably does not require additional installation. Just build and run app.

However, in case of difficulties, it is recommended to execute the following commands in the Terminal:
- For installing CocoaPods:
  > brew install cocoapods
- Navigate to the project folder using the commands cd and ls
- For installing pods in the project:
  > pod install

### Architecture

MVP (Model-View-Presenter) has been used as the main architecture.
This architecture is suitable for small projects while providing sufficient separation of responsibilities.

The majority of the UI is designed in storyboards for the sake of speed.
However, for demonstration purposes, one screen has been developed using an XIB file.

### Improvements and Enhancements

1. Used SwiftGen for texts.
2. Migrate from CocoaPods to SwiftPackageManager.
3. Add a coordinator and manage screens through it.
4. Use SnapKit for UI layout.
5. Introduce base classes for View and Presenter.
