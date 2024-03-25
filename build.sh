# build for macOS
swift build

# show destinations
xcodebuild -showdestinations -scheme FrameLoop

# build for iOS
xcodebuild -scheme FrameLoop  -destination 'platform=iOS Simulator,OS=17.0.1,name=iPhone 15 Pro'
