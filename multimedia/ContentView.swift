//
//  ContentView.swift
//  multimedia
//
//  Created by Alessandro Bonacchi on 03/01/23.
//
import AVKit
import SwiftUI

struct ContentView: View {
    
    @State var files: [File] = []
    @State var selectedItems = Set<UUID>()
    @State var urlImage = ""
    @State var urlVideo = ""
    @State var urlType = ""
    func AddElementToList(){
        self.LoadFiles()
    }
    
    func DeleteElementToList(id: UUID){
        self.files.removeAll(where: {$0.id==id})
    }
    
    func MultiDelete(){
        self.selectedItems.forEach { id in
            print(id)
            self.files.removeAll(where: {$0.id==id})
        }
    }
    
    func LoadFiles(){
        self.files.removeAll()
        let fm = FileManager.default
        let path = "/Users/alessandrobonacchi/Downloads/test/source/"
        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
                if !self.files.contains(where: {$0.path==item}){
                    let el = File(path: "/Users/alessandrobonacchi/Downloads/test/source/" + item,selected: true)
                    self.files.append(el)
                }

            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    func TestMethod(){
        self.LoadFiles()
        /*
        print(selectedItems)
        if self.selectedItems.count > 0
        {
            var id = self.selectedItems.first;
            var f = self.files.first(where: {$0.id==id})
            print(f!.path)
            self.urlImage=f!.path
        }
         */
        
        /*
        let fm = FileManager.default
        let path = "/Users/alessandrobonacchi/Downloads/test/source/"
        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
         */
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
