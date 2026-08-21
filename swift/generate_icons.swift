import AppKit

let args = CommandLine.arguments
guard args.count == 4 else {
    FileHandle.standardError.write("usage: generate_icons <out.png> <emoji> <hexcolor>\n".data(using: .utf8)!)
    exit(1)
}
let outPath = args[1]
let emoji = args[2]
let hex = args[3]

func color(from hex: String) -> NSColor {
    var s = hex.trimmingCharacters(in: .whitespaces)
    if s.hasPrefix("#") { s.removeFirst() }
    var v: UInt64 = 0
    Scanner(string: s).scanHexInt64(&v)
    let r = CGFloat((v >> 16) & 0xFF) / 255.0
    let g = CGFloat((v >> 8) & 0xFF) / 255.0
    let b = CGFloat(v & 0xFF) / 255.0
    return NSColor(srgbRed: r, green: g, blue: b, alpha: 1)
}

let size = NSSize(width: 512, height: 512)
let image = NSImage(size: size)
image.lockFocus()

let bg = color(from: hex)
let rect = NSRect(origin: .zero, size: size)
let path = NSBezierPath(roundedRect: rect.insetBy(dx: 8, dy: 8), xRadius: 115, yRadius: 115)
bg.setFill()
path.fill()

let fontSize: CGFloat = 270
let font = NSFont.systemFont(ofSize: fontSize)
let attrs: [NSAttributedString.Key: Any] = [.font: font]
let str = NSAttributedString(string: emoji, attributes: attrs)
let strSize = str.size()
let strRect = NSRect(x: (size.width - strSize.width) / 2, y: (size.height - strSize.height) / 2, width: strSize.width, height: strSize.height)
str.draw(in: strRect)
image.unlockFocus()

guard let tiff = image.tiffRepresentation,
      let rep = NSBitmapImageRep(data: tiff),
      let png = rep.representation(using: .png, properties: [:]) else {
    FileHandle.standardError.write("failed to encode png\n".data(using: .utf8)!)
    exit(1)
}
try! png.write(to: URL(fileURLWithPath: outPath))
