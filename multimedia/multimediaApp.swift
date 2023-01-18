//
//  multimediaApp.swift
//  multimedia
//
//  Created by Alessandro Bonacchi on 03/01/23.
//

import SwiftUI

struct VisualEffect: NSViewRepresentable {
  func makeNSView(context: Self.Context) -> NSView { return NSVisualEffectView() }
  func updateNSView(_ nsView: NSView, context: Context) { }
}

@main
struct multimediaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationTitle("Copia file su NAS")
                .background(VisualEffect())
        }.windowStyle(HiddenTitleBarWindowStyle())
    }
}
