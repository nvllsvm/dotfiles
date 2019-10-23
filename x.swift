import Quartz
import AppKit
import Swift
import Foundation

print("Hello")


// Create a Task instance
let task = Process()

// Set the task parameters
task.launchPath = "/bin/sh"
task.arguments = ["-c", "ls -l /tmp"]
 
// Create a Pipe and make the task
// put all the output there
let pipe = Pipe()
task.standardOutput = pipe

// Launch the task
task.launch()
 
// Get the data
let data = pipe.fileHandleForReading.readDataToEndOfFile()
let output = String(data: data, encoding: .utf8)

print(output!)

func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

    print("yay")
    if [.keyDown , .keyUp].contains(type) { var keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        if keyCode == 0 {
            keyCode = 6
        } else if keyCode == 6 {
            keyCode = 0
        }
        event.setIntegerValueField(.keyboardEventKeycode, value: 0)
    }
    return Unmanaged.passUnretained(event)
}

let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                      place: .headInsertEventTap,
                                      options: .defaultTap,
                                      eventsOfInterest: NSEvent.EventTypeMask.systemDefined,
                                      callback: myCGEventCallback,
                                      userInfo: nil) else {
                                        print("failed to create event tap")
                                        exit(1)
}

let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
CGEvent.tapEnable(tap: eventTap, enable: true)
print("Yo")
CFRunLoopRun()
