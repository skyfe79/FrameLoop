# FrameLoop

FrameLoop is a Swift package designed to synchronize drawing operations with the refresh rate of the display on both macOS and iOS platforms. It provides a simple API to manage frame update callbacks, allowing for smooth and efficient rendering in your applications.

## Features

- **Cross-Platform**: Works on both macOS and iOS.
- **Easy to Use**: Simplified API for managing frame updates.
- **Efficient**: Optimizes rendering to match the display's refresh rate.

## Installation

To integrate FrameLoop into your Swift package, add it as a dependency in your `Package.swift` file:

```swift:Package.swift
dependencies: [
    .package(url: "https://github.com/skyfe79/FrameLoop.git", from: "0.0.1")
]
```

## Usage

### Initializing FrameLoop

Create an instance of `FrameLoop` by providing a frame update callback. This callback receives the frames per second (fps) and delta time between frames.

```swift
let frameLoop = FrameLoop { fps, deltaTime in
    // Handle frame update
}
```

### Starting and Stopping the Frame Loop

To start receiving frame updates, call `start()` on your `FrameLoop` instance. To stop, call `stop()`.

```swift
frameLoop.start()

// When you want to stop receiving updates
frameLoop.stop()
```

### Checking if Frame Loop is Running

You can check if the frame loop is currently running by accessing the `isRunning` property.

```swift
if frameLoop.isRunning {
  print("Frame loop is currently running.")
} else {
  print("Frame loop is not running.")
}
```

### Adjusting Frame Rate

You can adjust the preferred frames per second (FPS) for the display link:

```swift
frameLoop.preferredFramesPerSecond = 30
```


## License

FrameLoop is released under the MIT license. See [LICENSE](LICENSE) for more information.
