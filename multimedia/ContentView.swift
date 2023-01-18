//
//  ContentView.swift
//  multimedia
//
//  Created by Alessandro Bonacchi on 03/01/23.
//
import AVKit
import SwiftUI

struct SheetView: View {
    @Binding var Overwrite : Bool
    @Binding var PhotoPath : String
    @Binding var VideoPath  : String
    @Binding var RAWPath  : String
    @Binding var TrashPath  : String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack{

            Toggle("Sovrascrivi", isOn: $Overwrite)
            Divider()
            TextField(
                "Percorso Photo",
                text: $PhotoPath
            )
            Divider()
            TextField(
                "Percorso Video",
                text: $VideoPath
            )
            Divider()
            TextField(
                "Percorso RAW",
                text: $RAWPath
            )
            Divider()
            TextField(
                "Percorso Cestino",
                text: $TrashPath
            )

            Button("Chiudi"){
                dismiss()
            }

            
        }.frame(
            width: 312,
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
    @State var PhotoPath = "/Users/alessandrobonacchi/Downloads/test/dest/photo"
    @State var VideoPath = "/Users/alessandrobonacchi/Downloads/test/dest/video"
    @State var RAWPath = "/Users/alessandrobonacchi/Downloads/test/dest/raw"
    @State var TrashPath = "/Users/alessandrobonacchi/Downloads/test/dest/cestino"
    
    @State private var showingSheet = false
    
    
    func AddElementToList(){
        self.LoadFiles()
    }
    
    func DeleteElementToList(id: UUID){
        self.files.removeAll(where: {$0.id==id})
    }
    
    func Copy(){
        let fm = FileManager.default
        do{
            try fm.copyItem(atPath: "/Users/alessandrobonacchi/Downloads/test/source/DSC04164.JPG", toPath: "/Users/alessandrobonacchi/Downloads/test/dest/photo/DSC04164.JPG")
        }catch{
        }

    }
    
    func MultiDelete(){
        self.selectedItems.forEach { id in
            print(id)
            self.files.removeAll(where: {$0.id==id})
        }
    }
    
    func LoadFiles(){
        //self.files.removeAll()
        let fm = FileManager.default
        let path = "/Users/alessandrobonacchi/Downloads/test/source/"
        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
                let el = File(path: "/Users/alessandrobonacchi/Downloads/test/source/" + item,selected: true)
                if !self.files.contains(where: {$0.fileNameWithoutExt==el.fileNameWithoutExt}){
                    self.files.append(el)
                }
                self.files = self.files.sorted(by: {$0.fileNameWithoutExt > $1.fileNameWithoutExt})

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
                    VStack{
                        Toggle("Sovrascrivi", isOn: $Overwrite)
                        Divider()
                        TextField(
                            "Percorso Photo",
                            text: $PhotoPath
                        )
                        Divider()
                        TextField(
                            "Percorso Video",
                            text: $VideoPath
                        )
                        Divider()
                        TextField(
                            "Percorso RAW",
                            text: $RAWPath
                        )
                        Divider()
                        TextField(
                            "Percorso Cestino",
                            text: $TrashPath
                        )
                        
                    }.frame(
                        width: 312,
                        alignment: .topLeading
                    ).padding(.trailing)
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
                                Text("Importa")
                            }
                    Divider()
                    Button("Show Sheet") {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        SheetView(Overwrite:self.$Overwrite, PhotoPath: self.$PhotoPath, VideoPath: self.$VideoPath,RAWPath: self.$RAWPath, TrashPath: self.$TrashPath )
                    }
            Divider()
                    Button(action: {self.Copy()}) {
                        Text("Copia")
                    }
                            Divider()
                            Button(action: {self.MultiDelete()}) {
                                Text("Elimina")
                            }
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
        }
            

    }
}

    
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
