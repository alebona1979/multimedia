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


// rm -rf /Users/alessandrobonacchi/Downloads/test/dest/raw/. && rm -rf /Users/alessandrobonacchi/Downloads/test/dest/video/. && rm -rf /Users/alessandrobonacchi/Downloads/test/dest/photo/. && rm -rf /Users/alessandrobonacchi/Downloads/test/dest/cestino/.
                                                                                                                          
import AVKit
import SwiftUI
//import AMSMB2

struct SheetView: View {
    @Binding var SourcePath : String
    @Binding var Overwrite : Bool
    @Binding var PhotoPath : String
    @Binding var VideoPath  : String
    @Binding var RAWPath  : String
    @Binding var TrashPath  : String
    @Environment(\.dismiss) var dismiss
    
    @State private var presentAlert = false
    
    func SaveSettings(){
        if self.CheckPaths(){
            UserDefaults.standard.set(self.SourcePath, forKey: "SourcePath")
            UserDefaults.standard.set(self.Overwrite, forKey: "Overwrite")
            UserDefaults.standard.set(self.PhotoPath, forKey: "PhotoPath")
            UserDefaults.standard.set(self.VideoPath, forKey: "VideoPath")
            UserDefaults.standard.set(self.RAWPath, forKey: "RAWPath")
            UserDefaults.standard.set(self.TrashPath, forKey: "TrashPath")
            dismiss()
        }else{
            self.presentAlert = true
        }
    }
    
    func CheckPaths() -> Bool {
        var isDir:ObjCBool = true
        let fm = FileManager.default
        if !fm.fileExists(atPath: self.SourcePath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.PhotoPath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.VideoPath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.RAWPath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.TrashPath, isDirectory: &isDir){
            return false
        }
        return true
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
                HStack {
                    Text("Percorso Origine")
                    Spacer()
                }
                TextField(
                    "Percorso Origine",
                    text: $SourcePath
                ).padding([.leading, .trailing, .bottom],6)
                HStack {
                    Toggle("Sovrascrivi file", isOn: $Overwrite)
                    Spacer()
                }
            }
            Group{
                HStack {
                    Text("Percorso Photo")
                    Spacer()
                }
                TextField(
                    "Percorso Photo",
                    text: $PhotoPath
                ).padding([.leading, .trailing, .bottom],6)
                HStack {
                    Text("Percorso Video")
                    Spacer()
                }
                TextField(
                    "Percorso Video",
                    text: $VideoPath
                ).padding([.leading, .trailing, .bottom],6)
                HStack {
                    Text("Percorso RAW")
                    Spacer()
                }
                TextField(
                    "Percorso RAW",
                    text: $RAWPath
                ).padding([.leading, .trailing, .bottom],6)
                HStack {
                    Text("Percorso Cestino")
                    Spacer()
                }
                TextField(
                    "Percorso Cestino",
                    text: $TrashPath
                ).padding([.leading, .trailing, .bottom],6)
            }
            HStack{
                Button(action: {dismiss()}) {
                    HStack {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                        Text("Chiudi")
                    }
                    .padding(8)
                }
                .cornerRadius(4)
                .buttonStyle(.plain)
                .controlSize(.large)
                Button(action:{SaveSettings()}) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Salva")
                    }        .alert(isPresented: $presentAlert) { // 4
                        
                        Alert(
                            title: Text("Errori"),
                            message: Text("Sono presenti alcuni percorsi inesistenti o irraggiungibili")
                        )
                    }
                    .padding(8)
                }
                .cornerRadius(4)
                .buttonStyle(.plain)
                .controlSize(.large)
            }

        }.frame(
            width: 640,
            alignment: .topLeading
        ).padding()
        
    }
}

struct ContentView: View {
    @State private var presentAlert = false
    @State private var downloadAmount = 0.0
    @State private var downloadTotal = 1.0
    @State private var downloadText = "Nessun file copiato"
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var files: [File] = []
    @State var selectedItems = Set<UUID>()
    @State var urlImage = ""
    @State var urlVideo = ""
    @State var urlType = ""
    


    /*
    @State var SourcePath = "/Users/alessandrobonacchi/Downloads/test/source/"
    @State var Overwrite = false
    @State var PhotoPath = "/Users/alessandrobonacchi/Downloads/test/dest/photo/"
    @State var VideoPath = "/Users/alessandrobonacchi/Downloads/test/dest/video/"
    @State var RAWPath = "/Users/alessandrobonacchi/Downloads/test/dest/raw/"
    @State var TrashPath = "/Users/alessandrobonacchi/Downloads/test/dest/cestino/"
    */
    @State var SourcePath = ""
    @State var Overwrite = false
    @State var PhotoPath = ""
    @State var VideoPath = ""
    @State var RAWPath = ""
    @State var TrashPath = ""

    
    @State private var showingSheet = false
    
    init(){
        let _sourcePath = UserDefaults.standard.string(forKey: "SourcePath")
        if _sourcePath != nil{
            self._SourcePath = State(initialValue: _sourcePath!)
        }
        self._Overwrite = State(initialValue: UserDefaults.standard.bool(forKey: "Overwrite"))
        let _photoPath = UserDefaults.standard.string(forKey: "PhotoPath")
        if _photoPath != nil{
            self._PhotoPath = State(initialValue: _photoPath!)
        }
        let _videoPath = UserDefaults.standard.string(forKey: "VideoPath")
        if _videoPath != nil{
            self._VideoPath = State(initialValue: _videoPath!)
        }
        let _rawPath = UserDefaults.standard.string(forKey: "RAWPath")
        if _rawPath != nil{
            self._RAWPath = State(initialValue: _rawPath!)
        }
        let _trashPath = UserDefaults.standard.string(forKey: "TrashPath")
        if _trashPath != nil{
            self._TrashPath = State(initialValue: _trashPath!)
        }
    }

    func CheckPaths() -> Bool {
        var isDir:ObjCBool = true
        let fm = FileManager.default
        if !fm.fileExists(atPath: self.SourcePath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.PhotoPath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.VideoPath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.RAWPath, isDirectory: &isDir){
            return false
        }
        if !fm.fileExists(atPath: self.TrashPath, isDirectory: &isDir){
            return false
        }
        return true
    }
    
    func AddElementToList(){
        self.LoadFiles()
    }
    
    func DeleteElementToList(id: UUID){
        self.files.removeAll(where: {$0.id==id})
    }
    
    func Copy(){
        if(self.files.count == 0){
            self.presentAlert=true
            return
        }
        let fm = FileManager.default
        var isDir:ObjCBool = true
        DispatchQueue.global().async {
            
            downloadTotal=(Double)(self.files.count)
            downloadAmount=0
            downloadText="Inizio copia files in corso..."
            self.files.forEach {
                file in
                downloadAmount=downloadAmount+1
                Thread.sleep(forTimeInterval: 0.1)
                if file.selected
                {
                    downloadText="Copia in corso di " + file.fileName+"..."
                    if file.type.lowercased()=="image"
                    {
                        let destYear=self.PhotoPath + String(file.year!) + "/"
                        if !fm.fileExists(atPath: destYear, isDirectory: &isDir){
                            do{
                                try fm.createDirectory(at: URL(fileURLWithPath: destYear, isDirectory: true), withIntermediateDirectories: true)
                            }catch{
                                print("Unexpected error: \(error).")
                            }
                        }
                        let destMonth = destYear + String(file.month!) + "/"
                        if !fm.fileExists(atPath: destMonth, isDirectory: &isDir){
                            do{
                                try fm.createDirectory(at: URL(fileURLWithPath: destMonth, isDirectory: true), withIntermediateDirectories: true)
                            }catch{}
                        }
                        let dest = destMonth + file.fileName
                        if(!fm.fileExists(atPath: dest) || Overwrite){
                            do{
                                try fm.copyItem(atPath: file.path, toPath: dest)
                            }catch{
                            }
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
                                if(!fm.fileExists(atPath: dest) || Overwrite){
                                    do{
                                        try fm.copyItem(atPath: file.RAWPath, toPath: dest)
                                    }catch{}
                                }

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
                        if(!fm.fileExists(atPath: dest) || Overwrite){
                            do{
                                try fm.copyItem(atPath: file.path, toPath: dest)
                            }catch{
                            }
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
                    if(!fm.fileExists(atPath: dest) || Overwrite){
                        do{
                            try fm.copyItem(atPath: file.path, toPath: dest)
                        }catch{
                        }
                    }

                }
                


            }
            downloadText="Copia completata"
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
    
    
    func LoadFiles(){
        let fm = FileManager.default
        let path = self.SourcePath
        print(path)
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            print(items)
            for item in items {
                print(item)
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
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
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
                ProgressView(downloadText, value: downloadAmount, total: downloadTotal)
                    .padding()
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
                            SheetView(SourcePath: self.$SourcePath, Overwrite:self.$Overwrite, PhotoPath: self.$PhotoPath, VideoPath: self.$VideoPath,RAWPath: self.$RAWPath, TrashPath: self.$TrashPath )
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
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                
                
            }
            .frame(
                minWidth: 0,
                maxWidth:  .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Color(NSColor.windowBackgroundColor))
        }.alert(isPresented: $presentAlert) { // 4
            
            Alert(
                title: Text("Errore"),
                message: Text("Non sono stati caricati file da copiare")
            )
        }
        .padding(8)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
