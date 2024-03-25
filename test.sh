# test for macOS
swift test

# test for iOS
xcodebuild -scheme FrameLoop  -destination 'platform=iOS Simulator,OS=17.0.1,name=iPhone 15 Pro' test