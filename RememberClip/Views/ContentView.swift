//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 20/08/23.
//

import SwiftUI

struct ContentView: View {
    @State var selectedType : Int = 1
    @State var showPreferences = false
    var body: some View {
        VStack{
            Picker("", selection: $selectedType) {
                Text("Saved").tag(0)
                Text("Clipboard").tag(1)
            }
            .pickerStyle(.segmented)
            ViewType(selectedType: $selectedType)
            Divider()
            Section{
                HStack{
                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                            .foregroundStyle(Color.primary)
                    }
                    .keyboardShortcut("q")
                    Spacer()
                    Button {
                        print("P pressed")
                        showPreferences = true
                    } label: {
                        Text("Preferences")
                            .foregroundStyle(Color.primary)
                    }
                    .keyboardShortcut(",")
 
                }
                .padding([.trailing])
            }
        }
        .padding()
        //.frame(width:450,height:450)
    }
}

//#Preview {
//    ContentView()
//}

struct ViewType:View {
    
    @State var searchText = ""
    @Binding var selectedType : Int
    var body: some View {
        switch selectedType{
        case 0:
            TextingView()
//                .keyboardShortcut("s")
        case 1:
            ClipboardView()
                .searchable(text: $searchText)
//                .keyboardShortcut("b")
        default:
            Text("Not selected anything")
        }
    }
}
