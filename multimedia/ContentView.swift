//
//  ContentView.swift
//  multimedia
//
//  Created by Alessandro Bonacchi on 03/01/23.
//
//
//
// rm -rf /Users/alessandrobonacchi/Downloads/test/dest/raw/*
// rm -rf /Users/alessandrobonacchi/Downloads/test/dest/video/*
// rm -rf /Users/alessandrobonacchi/Downloads/test/dest/photo/*
// rm -rf /Users/alessandrobonacchi/Downloads/test/dest/cestino/*

import AVKit
import SwiftUI

struct SheetView: View {
    @Binding var Overwrite : Bool
    @Binding var PhotoPath : String
    @Binding var VideoPath  : String
    @Binding var RAWPath  : String
    @Binding var TrashPath  : String
    @Environment(\.dismiss) var dismiss
    
    func Prova(){
        var prova = UserDefaults.standard.string(forKey: "Test")
       print(prova)
    }
    
    
    var body: some View {
        VStack{
            Group{
                HStack{
                    Spacer()
                    Text("Impostazioni")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            }
            Group{
                Toggle("Sovrascrivi file", isOn: $Overwrite)
                Text("Percorso Photo")
                TextField(
                    "Percorso Photo",
                    text: $PhotoPath
                ).padding([.leading, .trailing, .bottom],6)
                Text("Percorso Video")
                TextField(
                    "Percorso Video",
                    text: $VideoPath
                ).padding([.leading, .trailing, .bottom],6)
                Text("Percorso RAW")
                TextField(
                    "Percorso RAW",
                    text: $RAWPath
                ).padding([.leading, .trailing, .bottom],6)
                Text("Percorso Cestino")
                TextField(
                    "Percorso Cestino",
                    text: $TrashPath
                ).padding([.leading, .trailing, .bottom],6)
            }
            Button(action: {UserDefaults.standard.set("Prova", forKey: "Test")}) {
                HStack {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                    Text("Salva")
                }
                .padding(8)
            }
            .cornerRadius(4)
            .buttonStyle(.bordered)
            .controlSize(.large)
            Button(action:{Prova()}) {
                HStack {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                    Text("Recupera")
                }
                .padding(8)
            }
            .cornerRadius(4)
            .buttonStyle(.bordered)
            .controlSize(.large)
            Button(action: {dismiss()}) {
                HStack {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                    Text("Chiudi")
                }
                .padding(8)
            }
            .cornerRadius(4)
            .buttonStyle(.bordered)
            .controlSize(.large)
        }.frame(
            width: 640,
            alignment: .topLeading
        ).padding()
        
    }
}

struct ContentView: View {
    
    @State var files: [File] = []
    @State var selectedItems = Set<UUID>()
    @State var urlImage = ""
    @State var urlVideo = ""
    @State var urlType = ""
    
    @State var Overwrite = false
    @State var SourcePath = "/Users/alessandrobonacchi/Downloads/test/source/"
    @State var PhotoPath = "/Users/alessandrobonacchi/Downloads/test/dest/photo/"
    @State var VideoPath = "/Users/alessandrobonacchi/Downloads/test/dest/video/"
    @State var RAWPath = "/Users/alessandrobonacchi/Downloads/test/dest/raw/"
    @State var TrashPath = "/Users/alessandrobonacchi/Downloads/test/dest/cestino/"
    
    @State private var showingSheet = false
    

    func AddElementToList(){
        self.LoadFiles()
    }
    
    func DeleteElementToList(id: UUID){
        self.files.removeAll(where: {$0.id==id})
    }
    
    func Copy(){
        let fm = FileManager.default
        var isDir:ObjCBool = true
        self.files.forEach {
            file in
            if file.selected
            {
                if file.type.lowercased()=="image"
                {
                    let destYear=self.PhotoPath + String(file.year!) + "/"
                    if !fm.fileExists(atPath: destYear, isDirectory: &isDir){
                        do{
                            try fm.createDirectory(at: URL(fileURLWithPath: destYear, isDirectory: true), withIntermediateDirectories: true)
                        }catch{}
                    }
                    let destMonth = destYear + String(file.month!) + "/"
                    if !fm.fileExists(atPath: destMonth, isDirectory: &isDir){
                        do{
                            try fm.createDirectory(at: URL(fileURLWithPath: destMonth, isDirectory: true), withIntermediateDirectories: true)
                        }catch{}
                    }
                    let dest = destMonth + file.fileName
                    do{
                        try fm.copyItem(atPath: file.path, toPath: dest)
                    }catch{
                    }
                    // per ogni immagine si deve andare a verificare se esiste anche il corrispondente raw
                    if !file.RAWPath.isEmpty{
                        if fm.fileExists(atPath: file.RAWPath){
                            let destYearRAW=self.RAWPath + String(file.year!) + "/"
                            if !fm.fileExists(atPath: destYearRAW, isDirectory: &isDir){
                                do{
                                    try fm.createDirectory(at: URL(fileURLWithPath: destYearRAW, isDirectory: true), withIntermediateDirectories: true)
                                }catch{}
                            }
                            let destMonthRAW = destYearRAW + String(file.month!) + "/"
                            if !fm.fileExists(atPath: destMonthRAW, isDirectory: &isDir){
                                do{
                                    try fm.createDirectory(at: URL(fileURLWithPath: destMonthRAW, isDirectory: true), withIntermediateDirectories: true)
                                }catch{}
                            }
                            let dest = destMonthRAW + file.RAWfileName
                            do{
                                try fm.copyItem(atPath: file.RAWPath, toPath: dest)
                            }catch{}
                        }
                    }
                }
                else if file.type.lowercased()=="video"{
                    let destYear=self.VideoPath + String(file.year!) + "/"
                    if !fm.fileExists(atPath: destYear, isDirectory: &isDir){
                        do{
                            try fm.createDirectory(at: URL(fileURLWithPath: destYear, isDirectory: true), withIntermediateDirectories: true)
                        }catch{}
                    }
                    let destMonth = destYear + String(file.month!) + "/"
                    if !fm.fileExists(atPath: destMonth, isDirectory: &isDir){
                        do{
                            try fm.createDirectory(at: URL(fileURLWithPath: destMonth, isDirectory: true), withIntermediateDirectories: true)
                        }catch{}
                    }
                    let dest = destMonth + file.fileName
                    do{
                        try fm.copyItem(atPath: file.path, toPath: dest)
                    }catch{
                    }
                    
                }
            }else{
                let destYear=self.TrashPath + String(file.year!) + "/"
                if !fm.fileExists(atPath: destYear, isDirectory: &isDir){
                    do{
                        try fm.createDirectory(at: URL(fileURLWithPath: destYear, isDirectory: true), withIntermediateDirectories: true)
                    }catch{}
                }
                let destMonth = destYear + String(file.month!) + "/"
                if !fm.fileExists(atPath: destMonth, isDirectory: &isDir){
                    do{
                        try fm.createDirectory(at: URL(fileURLWithPath: destMonth, isDirectory: true), withIntermediateDirectories: true)
                    }catch{}
                }
                let dest = destMonth + file.fileName
                do{
                    try fm.copyItem(atPath: file.path, toPath: dest)
                }catch{
                }
            }
            
            
            
        }
    }
    
    func fileModificationDate(url: URL) -> Date? {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            return attr[FileAttributeKey.modificationDate] as? Date
        } catch {
            return nil
        }
    }
    
    func MultiDelete(){
        self.selectedItems.forEach { id in
            self.files.removeAll(where: {$0.id==id})
        }
    }
    
    func FindRAWForImage(){
        
    }
    
    func LoadFiles(){
        let fm = FileManager.default
        let path = self.SourcePath
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                let el = File(path: self.SourcePath + item,selected: true, RAWPath: "")
                // i raw non si importano
                if el.type.lowercased() == "image" || el.type.lowercased() == "video"{
                    if !self.files.contains(where: {$0.fileNameWithoutExt==el.fileNameWithoutExt}){
                        self.files.append(el)
                        
                    }
                }
                self.files = self.files.sorted(by: {$0.fileNameWithoutExt > $1.fileNameWithoutExt})
                
            }
            // assign RAW path to images
            for item in items {
                let el = File(path: self.SourcePath + item,selected: true, RAWPath: "")
                if el.type.lowercased() == "raw"{
                    let f=self.files.firstIndex(where: {$0.fileNameWithoutExt==el.fileNameWithoutExt})
                    if (f != nil){
                        
                        self.files[f!].RAWPath=self.SourcePath + item
                        
                    }
                }
            }
            for file in self.files {
                print(file.RAWPath)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
    }
    
    func TestMethod(){
        self.LoadFiles()
    }
    
    
    
    var body: some View {
        
        HStack {
            VStack {
                List($files,
                     id: \.id,
                     selection: $selectedItems,
                     
                     rowContent: {$file in
                    
                    HStack{
                        Toggle("", isOn: $file.selected)
                        if file.type=="Image"{
                            Image(systemName: "photo")
                        }else if file.type=="Video"{
                            Image(systemName: "video")
                        }else{
                            Image(systemName: "doc")
                        }
                        Text(file.fileNameWithoutExt)
                            .fontWeight(.bold)
                        
                    }
                    .padding(6)
                    
                }).frame(width: 384)
                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                    .scrollContentBackground(.hidden)
            }
            
            VStack(alignment: .leading){
                
                HStack {
                    Spacer()
                    Text("Importa file multimediali su NAS")
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                }
                HStack{
                    
                    Spacer()
                    if self.urlType.lowercased()=="image"{
                        if NSImage(contentsOf: URL(fileURLWithPath: self.urlImage)) == nil{
                            Image(nsImage: NSImage())
                        }else{
                            let imm = NSImage(contentsOf: URL(fileURLWithPath: self.urlImage))!
                            Image(nsImage: imm)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                    } else if self.urlType.lowercased()=="video"{
                        let player = AVPlayer(url: URL(fileURLWithPath: self.urlVideo))
                        VideoPlayer(player: player)
                            .onAppear() {
                                player.play()
                            }
                    }
                    Spacer()
                }
                .onChange(of: selectedItems, perform: {value in
                    let id = selectedItems.first;
                    let f = self.files.first(where: {$0.id==id})
                    if f?.type.lowercased()=="image"{
                        self.urlType="image"
                        self.urlImage=f!.path
                    }
                    else if f?.type.lowercased()=="video"{
                        self.urlType="video"
                        self.urlVideo=f!.path
                    }else{
                        self.urlType="nd"
                    }
                    
                })
                
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {self.AddElementToList()}) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Importa")
                        }.padding(8)
                    }
                        .cornerRadius(4)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    Divider()
                    Button(action: {showingSheet.toggle()}) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                            Text("Impostazioni")
                        }.padding(8)
                    }
                        .cornerRadius(4)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .sheet(isPresented: $showingSheet) {
                            SheetView(Overwrite:self.$Overwrite, PhotoPath: self.$PhotoPath, VideoPath: self.$VideoPath,RAWPath: self.$RAWPath, TrashPath: self.$TrashPath )
                        }
                    Divider()
                    Button(action: {self.Copy()}) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copia")
                        }.padding(8)
                    }
                        .cornerRadius(4)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    Divider()
                    Button(action: {self.MultiDelete()}) {
                        HStack {
                            Image(systemName: "trash.circle.fill")
                            Text("Elimina")
                        }.padding(8)
                    }
                        .cornerRadius(4)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    Spacer()
                }.frame(height: 24)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                
                
            }
            .frame(
                minWidth: 0,
                maxWidth:  .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Color(NSColor.windowBackgroundColor))
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
