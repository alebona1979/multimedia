//
//  File.swift
//  multimedia
//
//  Created by Alessandro Bonacchi on 07/01/23.
//

import Foundation

struct File:Identifiable, Hashable{
    var id = UUID()
    
    
    var path: String
    var selected: Bool
    var fileName: String{
        get{
            var fileData = NSURL(fileURLWithPath: path as String)
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
          var fileData = NSURL(fileURLWithPath: path as String)
          return (fileData.pathExtension)!    }
    }
}
