
setup:
	swiftgen
	xcodegen
	pod install

# Reset the project for a clean build
reset:
	rm -rf *.xcodeproj
	rm -rf *.xcworkspace
	rm -rf Pods/
	rm Podfile.lock

gen:
	swiftgen

test:
	rm -rf TestResults
	rm -rf TestResults.xcresult
	xcodebuild test -workspace CoachTimer.xcworkspace -scheme CoachTimerTests -destination 'platform=iOS Simulator,name=iPhone X' -resultBundlePath TestResults

