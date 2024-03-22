//
//  SettingsView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 27/02/24.
//

import Foundation
import SwiftUI
import AppKit
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
            
            Toggle("Show Search bar in copied tab", isOn: $preferences.showSearchBar)
            
            Toggle("Show Scroll Indication",isOn: $preferences.scrollIndication)
            
            HStack{
                Text("No. of clips shown")
                TextField("25", text: $preferences.numberOfClips)
                
            }
            
            Picker("Appearance", selection: $preferences.appearanceSelection) {
                pickerContent()
            }
            
            HStack{
                ColorPicker("Theme Color", selection: $preferences.themeColor, supportsOpacity: true)
                Button("Default"){
                    preferences.themeColor = .blue
                }
            }
            
            
        }
        .onChange(of: preferences.numberOfClips){ newValue in
            
        }
        .padding(.top, 10)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }
    static func showWindow() {
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 350),
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



