//
//  extraview.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/09/23.
//

import SwiftUI
import Combine

struct ClipboardView: View {
    
    @State var placeholderText = "Tap the clip you want to copy or search here...."
    @State private var searchText = ""
    @State var isEditing = false
    
    @FocusState fileprivate var focusedField: Bool
    
    @State var closed = false
    
    init(){
        isEditing = false
        focusedField = false
    }
    
    var body: some View {
        VStack{
            
            HStack{
                TextField(placeholderText, text: $searchText)
                    .focusable(false)
                    .onReceive(Just(searchText)) { text in
                        if(text.isEmpty){
                            self.isEditing = false
                            focusedField = false
                        }
                        else{
                            self.isEditing = true
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
                            self.isEditing = false
                            self.searchText = ""
                            self.focusedField = false
                        }, label: {
                            Text("Cancel")
                        })
                        //                    Button("Cancel", role: .cancel, action: {
                        //                        self.isEditing = false
                        //                        self.searchText = ""
                        //                        self.focusedField = false
                        //                    })
                        .padding(.trailing, 3)
                        .transition(.move(edge: .trailing))
                        //}
                    }
                }
                //            .onTapGesture {
                //                //self.isEditing = true
                //                //focusedField = false
                //            }
            }
            .onAppear{
                focusedField = false
            }
            .onDisappear{
                
                focusedField = false
            }
            
            Divider()
                .padding(.bottom,2)
            ClipboardItemsView(searchText: searchText,closed: $closed)
                .onAppear {
                    focusedField = false
                }
                .onTapGesture {
                    searchText = ""
                    focusedField = false
                }
        }
        .onChange(of: closed, perform: { _ in
            searchText = ""
            focusedField = false
        })
        
        .onAppear {
            focusedField = false
            
        }
        .onDisappear{
            searchText = ""
            focusedField = false
            closed = false
        }
        
        
    }
    
}
