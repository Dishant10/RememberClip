//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 20/08/23.
//

import SwiftUI


struct ContentView: View {
    
    @State var selectedType : Int = 1
    //@State var showPreferences = false
    @State private var isHovering : Bool = false
    
    var persistentController = PersistenceController.shared
    
    var body: some View {
        Section{
            Picker("", selection: $selectedType) {
                Text("Saved").tag(0)
                Text("Clipboard").tag(1)
            }
            .padding([.top,.leading,.trailing])
            .pickerStyle(.segmented)
            ViewType(selectedType: $selectedType)
                .padding([.leading,.trailing])
        }
            Divider()
            Section{
                //                    Button {
                //                        NSApplication.shared.terminate(nil)
                //                    } label: {
                //                        HStack{
                //                            Text("Quit")
                //                            Spacer()
                //                            Text(" ⌘ Q")
                //                                .foregroundStyle(Color.secondary)
                //                        }
                //                        .padding(.all,4)
                //                        //.background(isHovering ? Color.gray.opacity(0.2) : .clear)
                //                            .foregroundStyle(Color.primary)
                //                    }
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(isHovering ? .gray.opacity(0.2) : .clear)
                        .frame(maxWidth: .infinity,maxHeight:25)
                    
                    HStack{
                        Text("Quit")
                        Spacer()
                        Text(" ⌘ Q ")
                            .foregroundStyle(isHovering == true ? .white : Color.secondary)
                    }
                    
                    .padding([.leading,.trailing],7)
                     .padding([.top,.bottom],3)
                }.onTapGesture {
                    NSApplication.shared.terminate(nil)
                }
                .padding([.leading,.trailing],5)
                .padding(.bottom,7)
                .onHover(perform: { hovering in
                    isHovering = hovering
                })
                .keyboardShortcut("q")
                //Spacer()
                //                    Button {
                //                        print("P pressed")
                //                        showPreferences = true
                //                    } label: {
                //                        Text("Preferences")
                //                            .foregroundStyle(Color.primary)
                //                    }
                //                    .keyboardShortcut(",")
                
                //.padding([.trailing])
            }
            
        //}
//        .padding()
        .environment(\.managedObjectContext,persistentController.container.viewContext)
    }
}

struct ViewType:View {
    
    @State var searchText = ""
    @Binding var selectedType : Int
    var body: some View {
        switch selectedType{
        case 0:
            TextingView()
        case 1:
            ClipboardView()
        default:
            Text("Not selected anything")
        }
    }
}
