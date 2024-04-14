//
//  SettingsView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 27/02/24.
//

import Foundation
import SwiftUI
import AppKit
import Combine
import LaunchAtLogin

#if os(macOS)

typealias PlatformColor = NSColor
extension Color {
    init(platformColor: PlatformColor) {
        self.init(nsColor: platformColor)
    }
}

#endif
struct SettingsView: View {
    
    @ObservedObject var preferences = Preferences()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
            
            Toggle("Don't remember clipboard history",isOn: $preferences.dontRemember)
            
            Toggle("Show search bar in clipboard tab", isOn: $preferences.showSearchBar)
            
            Toggle("Show Scroll Indication",isOn: $preferences.scrollIndication)
            
            Toggle("Allow clip to be pinned",isOn: $preferences.allowPinning)
            
            Toggle("Pause clipboard functionality\n(You will not be able to copy and paste\nif turned on)", isOn: $preferences.pauseCopyPaste)
            HStack{
                Text("No. of clips shown")
                TextField("25", text: $preferences.numberOfClips)
                    .onReceive(Just($preferences.numberOfClips)) { _ in preferences.limitText(3) }
                
            }
            
            Picker("Appearance", selection: $preferences.appearanceSelection) {
                pickerContent()
            }
            
            HStack{
                ColorPicker("Theme Color", selection: $preferences.themeColor, supportsOpacity: true)
                    .padding(.trailing)
                Button("Default"){
                    preferences.themeColor = .blue
                }
            }
            
            
        }
        .onChange(of: preferences.numberOfClips, perform: { newValue in
            if newValue.isEmpty == false {
                guard let validEntry = Int(newValue) else {
                    preferences.numberOfClips = "25"
                    return
                }
            }
        })
        .padding(.top, 10)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }
    static func showWindow() {
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 370),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: false
        )
        
        window.title = "RememberClip Preferences"
        window.contentView = NSHostingView(rootView: SettingsView())
        window.makeKeyAndOrderFront(nil)
        window.level = .floating
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        let controller = NSWindowController(window: window)
        controller.showWindow(self)
        window.makeKeyAndOrderFront(nil)
        window.center()
        window.orderFrontRegardless()
        
    }
    
    
    @ViewBuilder
    func pickerContent() -> some View {
        ForEach(preferences.pickerValues, id: \.self) {
            Text($0)
        }
    }
}



