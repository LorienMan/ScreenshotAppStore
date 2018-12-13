DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [ "$4" == "" ]; then
    echo "Usage: sh snapshot_appstore.sh [DEVICE UUID] [TEXT TO ENTER IN APPSTORE] [PAGES TO SCROLL] [DELAY (5s 10m 1h)]"
    exit
fi

while true; do 
	cd $DIR
	rm -rf ./DerivedData
	mkdir ./DerivedData

	echo "let requestString = \"$2\"\nlet pagesNumber = $3\n" > ./SnapshotAppstoreUITests/Configuration.swift

	set -o pipefail && xcodebuild -scheme SnapshotAppstoreUITests -project ./SnapshotAppstore.xcodeproj -derivedDataPath './DerivedData' -destination "platform=iOS,id=$1" FASTLANE_SNAPSHOT=YES build test | tee ./DerivedData/SnapshotAppstoreUITests-SnapshotAppstoreUITests.log | xcpretty

	test_result=$(find ./DerivedData/Logs/Test -name '*.xcresult')
	./SnapshotAppstoreGrabBin $test_result "$DIR/Screenshots"

	echo "Sleeping for $4"
	sleep $4
done