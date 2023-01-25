//
//  File.swift
//  multimedia
//
//  Created by Alessandro Bonacchi on 07/01/23.
//

import Foundation

func fileModificationDate(url: URL) -> Date? {
    do {
        let attr = try FileManager.default.attributesOfItem(atPath: url.path)
        return attr[FileAttributeKey.modificationDate] as? Date
    } catch {
        return nil
    }
}

struct File:Identifiable, Hashable{
    var id = UUID()
    
    
    var path: String
    var selected: Bool
    var fileName: String{
        get{
            let fileData = NSURL(fileURLWithPath: path as String)
            return (fileData.lastPathComponent)!
        }
    }
    var fileNameWithoutExt: String{
        get{
            let index = fileName.lastIndex(of: ".") ?? fileName.endIndex
            let beginning = fileName[..<index]
            return String(beginning)
        }
    }
    var type: String {
        get{
            if(imageExtension.contains(ext.lowercased())){
                return "Image"
            }
            if(rawExtension.contains(ext.lowercased())){
                return "Raw"
            }
            if(videoExtension.contains(ext.lowercased())){
                return "Video"
            }
            return "nd"
        }
    }
    var ext: String {
      get {
          let fileData = NSURL(fileURLWithPath: path as String)
          return (fileData.pathExtension)!    }
    }
    var date: Date? {
        get{
            return fileModificationDate(url: URL(fileURLWithPath: path))
        }
    }
    var month: Int? {
        get{
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: date!)
            return dateComponents.month
        }
    }
    var year: Int? {
        get{
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: date!)
            return dateComponents.year
        }
    }
}
