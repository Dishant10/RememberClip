//
//  TextingView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/08/23.
//

import Foundation
import SwiftUI
import CoreData

struct TextingView : View {
    
    @FetchRequest(fetchRequest: SavedText.fetch(), animation: .bouncy) var texts
    @Environment(\.managedObjectContext) var context
    
    @State var textInput1 : String = ""
    
    @FocusState private var focusedField: Bool
    @StateObject var appDelegate = AppDelegate()
    @Environment(\.dismiss) private var dismiss
    @State var shortcutIndex : Int = 0
    
    var body : some View {
        VStack{
            Section(){
                Text("Save the text that you regularly need to copy and paste.")
                    .padding(.top,3)
                    .foregroundStyle(.secondary)
            }
            Divider()
                .padding(.bottom)
            ScrollView(.vertical){
                
                ForEach(texts,id: \.self){ text in
                    VStack(spacing:10){
                        HStack{
                            Text(text.savedText)
                                .lineLimit(1)
                                .onTapGesture {
                                    focusedField = false
                                }
                            Spacer()
                            Button {
                                let pasteboard = NSPasteboard.general
                                pasteboard.declareTypes([.string], owner: nil)
                                pasteboard.setString(text.savedText, forType: .string)
                                dismiss()
                            } label: {
                                Image(systemName: "paperclip")
                                    .foregroundStyle(Color.primary)
                            }
                            .keyboardShortcut("1")
                            Button {
                                SavedText.delete(text: text)
                                PersistenceController.shared.save()
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                }
            }
//                .scaledToFill()
//                .frame(maxWidth: .infinity,maxHeight: .infinity)
//                .listStyle(.plain)
//                .listRowSeparator(.hidden)
//                .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
            
            HStack{
                TextField("Enter Text",text: $textInput1)
                    .focused($focusedField)
                    .textFieldStyle(.roundedBorder)
                Button {
                    if textInput1 != "" {
                        _ = SavedText(savedText: textInput1, context: context)
                        PersistenceController.shared.save()
                        textInput1 = ""
                        focusedField = false
                    }
                    else {
                        focusedField = false
                    }
                } label: {
                    Text("Save")
                        .foregroundStyle(Color.secondary)
                }
                
            }
            .padding(.top)
        }
        .onDisappear{
            
            focusedField = false
        }
        .onTapGesture {
            focusedField = false
        }
    }
}
