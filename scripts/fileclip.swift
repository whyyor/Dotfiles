// Put file references on the macOS pasteboard so GUI apps accept Cmd+V as an attachment.
// Build: swiftc -O fileclip.swift -o ~/.local/bin/fileclip
import AppKit

let paths = CommandLine.arguments.dropFirst().map {
    URL(fileURLWithPath: $0).standardizedFileURL.path
}

guard !paths.isEmpty else {
    FileHandle.standardError.write(Data("fileclip: no files given\n".utf8))
    exit(1)
}

let missing = paths.filter { !FileManager.default.fileExists(atPath: $0) }
guard missing.isEmpty else {
    FileHandle.standardError.write(Data("fileclip: not found: \(missing.joined(separator: ", "))\n".utf8))
    exit(1)
}

let pb = NSPasteboard.general
pb.clearContents()

// one item per file so modern apps see every file
pb.writeObjects(paths.map { p -> NSPasteboardItem in
    let item = NSPasteboardItem()
    item.setString(URL(fileURLWithPath: p).absoluteString, forType: .fileURL)
    return item
})

// legacy type for old apps, and it forces a synchronous commit before we exit
pb.setPropertyList(paths, forType: .init("NSFilenamesPboardType"))

print("fileclip: copied \(paths.count) file(s)")
