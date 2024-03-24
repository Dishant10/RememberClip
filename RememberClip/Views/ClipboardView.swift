//
//  extraview.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/09/23.
//

import SwiftUI
import Combine

struct ClipboardView: View {
    
    @ObservedObject var preferences = Preferences()
    
    @State var placeholderText = "Tap the clip you want to copy or search here...."
    @State private var searchText = ""
    @State var isEditing = false
    @State var closed = false
    
    @FocusState fileprivate var focusedField: Bool
    
    init(){
        isEditing = false
        focusedField = false
    }
    
    var body: some View {
        VStack{
            
            if preferences.showSearchBar {
                HStack{
                    TextField(placeholderText, text: $searchText)
                        .focusable(false)
                        .onReceive(Just(searchText)) { text in
                            if(text.isEmpty){
                                withAnimation {
                                    self.isEditing = false
                                    focusedField = false
                                }
                            }
                            else{
                                withAnimation {
                                    self.isEditing = true
                                }
                            }
                        }
                        .keyboardShortcut("s", modifiers: .shift)
                        .focused($focusedField)
                        .padding(.horizontal, 4)
                        .textFieldStyle(.roundedBorder)
                        .cornerRadius(8)
                    if isEditing {
                        withAnimation {
                            Button(action: {
                                withAnimation {
                                    self.isEditing = false
                                    self.searchText = ""
                                    self.focusedField = false
                                    
                                }
                            }, label: {
                                Text("Cancel")
                            })
                            .padding(.trailing, 3)
                            .transition(.move(edge: .trailing))
                        }
                    }
                }
                .onAppear{
                    focusedField = false
                }
                .onDisappear{
                    
                    focusedField = false
                }
                
                Divider()
                    .padding(.bottom,2)
            }
            ClipboardItemsView(searchText: searchText,closed: $closed)
                .onAppear {
                    if preferences.showSearchBar{
                        focusedField = false
                    }
                }
                .onTapGesture {
                    if preferences.showSearchBar {
                        searchText = ""
                        focusedField = false
                    }
                }
        }
        .onChange(of: closed, perform: { _ in
            if preferences.showSearchBar {
                withAnimation {
                    searchText = ""
                    focusedField = false
                }
                
            }
        })
        
        .onAppear {
            if preferences.showSearchBar {
                focusedField = false
            }
            
        }
        .onDisappear{
            if preferences.showSearchBar {
                searchText = ""
                focusedField = false
                closed = false
            }
        }
        
        
    }
    
}
