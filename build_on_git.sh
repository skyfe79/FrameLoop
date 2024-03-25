# build for macOS
swift build

# show destinations
xcodebuild -showdestinations -scheme FrameLoop

# build for iOS
xcodebuild -scheme FrameLoop  -destination 'platform=iOS Simulator,OS=16.2,name=iPhone 14 Pro'
