//
//  CBZComic.swift
//  Commic
//
//  Created by Vitor Silva on 15/02/21.
//

import Cocoa
import ZIPFoundation

class CBZComic: NSObject, ComicSource {
    func name() -> String {
        return filename
    }
    
    var pages: [NSImage?]
    let archive: Archive!
    var pagePaths: [(String, Entry)]
    var queue: DispatchQueue
    var filename: String
    var lastSeen: [Int] = [Int]()
    
    
    init?(withData data: Data, name: String = "Unknown Name") {
        archive = Archive.init(data: data, accessMode: .read, preferredEncoding: .utf8)
        
        if archive == nil {
            return nil
        }
        
        pagePaths = [(String, Entry)]()
        pages = [NSImage?]()
        
        for key in archive! {
            let path = key.path
            if path.hasSuffix(".png") || path.hasSuffix(".jpg") {
                pagePaths.append((path, key))
                pages.append(nil)
            }
        }
        
        pagePaths.sort(by:) {$0.0 < $1.0}
        
        queue = DispatchQueue.init(label: "imageLoader", qos: .background, attributes: .init(), autoreleaseFrequency: .inherit, target: nil)
        
        filename = name
    }
    
    func numberOfPages() -> Int {
        return pages.count
    }
    
    func page(at: Int) -> NSImage {
        return pages[at]!
    }
    
    func hasPage(at: Int) -> Bool {
        if pages[at] == nil {
            return false
        } else {
            return true
        }
    }
    
    func onPageLoaded(at index: Int, completion handler: @escaping () -> ()) {
        if hasPage(at: index) {
            handler()
        } else {
            queue.async { [self] in
                let entry = pagePaths[index].1
                let size = entry.uncompressedSize
                var buff = Data.init(capacity: size)
                
                let _ = try! archive.extract(entry, bufferSize: UInt32(size), skipCRC32: true, progress: nil, consumer: {
                    data in
                    buff.append(data)
                })
                
                lastSeen.append(index)
                if lastSeen.count > 10 {
                    pages[lastSeen.removeFirst()] = nil
                }
                
                let image = NSImage(data: buff)!
                pages[index] = image
                
                handler()
            }
        }
    }
}
