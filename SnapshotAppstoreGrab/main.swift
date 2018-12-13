//
//  main.swift
//  SnapshotAppstoreGrab
//
//  Created by Ilya Amelchenkov on 13/12/2018.
//  Copyright © 2018 Aviasales. All rights reserved.
//

import Foundation

let testPath = CommandLine.arguments[1]
let screenshotsDir = CommandLine.arguments[2]
let plistFilePath = testPath + "/TestSummaries.plist"

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"

let fm = FileManager.default

let currentScreehsotsDir = screenshotsDir + "/" + dateFormatter.string(from: Date())
do {
    try fm.createDirectory(atPath: currentScreehsotsDir, withIntermediateDirectories: true, attributes: [:])
} catch {
    print("Failed to create dir: \(currentScreehsotsDir)")
}

func main() {
    guard let dict = NSDictionary(contentsOfFile: plistFilePath) as? [AnyHashable: Any] else {
        print("Failed to load")
        return
    }

    let testableSummaries = dict["TestableSummaries"] as! [[AnyHashable: Any]]
    let tests = testableSummaries[0]["Tests"] as! [[AnyHashable: Any]]
    let subtests1 = tests[0]["Subtests"] as! [[AnyHashable: Any]]
    let subtests2 = subtests1[0]["Subtests"] as! [[AnyHashable: Any]]
    let subtests3 = subtests2[0]["Subtests"] as! [[AnyHashable: Any]]
    let activitySummaries = subtests3[0]["ActivitySummaries"] as! [[AnyHashable: Any]]

    var count = 0
    for activitySummary in activitySummaries {
        if (activitySummary["Title"] as? String) == "Set device orientation to Unknown" {
            let attachments = activitySummary["Attachments"] as! [[AnyHashable: Any]]
            if let firstAttachment = attachments.first, let fileName = firstAttachment["Filename"] as? String {
                count += 1

                let oldPath = testPath + "/Attachments/" + fileName
                do {
                    try fm.copyItem(atPath: oldPath, toPath: currentScreehsotsDir + "/Appstore_\(count).\(fileName.components(separatedBy: ".").last!)")
                    print("Copied \(fileName)")
                } catch {
                    print("Failed to copy \(fileName)")
                }
            }
        }
    }
}

main()
