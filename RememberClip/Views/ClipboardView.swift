//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/08/23.
//

import SwiftUI
import OnPasteboardChange

struct ClipboardView: View {
    
    @FetchRequest(fetchRequest: ClipboardItem.fetch(), animation: .bouncy) var texts
    @Environment(\.managedObjectContext) var context
    @ObservedObject var vm = ClipboardItem()
    
    @StateObject var clipboardItems = ClipboardItems()
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    var clipboardCopyItems : [String] = []
    var body: some View {
        VStack(alignment: .leading)
        {
            Section(){
                Text("Select the clip you want to add to your clipboard")
                    .padding(.top,3)
                    .foregroundStyle(Color.secondary)
            }
            Divider()
                .padding(.bottom)
            ScrollView{
                
                ForEach(texts, id: \.self) { item in
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(item.hoverAvailable == true ? .blue : .clear)
                            Row(clipboardText: item.text)
                                .foregroundStyle(item.hoverAvailable == true ? .white : Color.primary)
                                .padding(.leading,4)
                                .padding([.top,.bottom],3)
                        }
                        if item.hoverAvailable{
                            Button {
                                print("Tapped")
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                    .onHover{ hovering in
                        if texts.count > 0 {
                            item.hoverAvailable = hovering
                        }
                    }
                    .onTapGesture(count:1) {
                        clipboardItems.copyItem(text: item.text)
                        item.hoverAvailable = false
                        dismiss()
                    }
                    .onPasteboardChange {
                        readClipboardItems()
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
                    
                }
            }
            .padding(.bottom)
            Button {
                
                vm.deleteAll()
                
            } label: {
                Text("Clear")
                    .foregroundStyle(Color.secondary)
            }
            Button {
                readClipboardItems()
            } label: {
                Text("Refresh")
            }
            
            //Spacer()
        }
        //.padding(.bottom)
        .onAppear(perform: {
            
            readClipboardItems()
            
        })
    }
    
    func readClipboardItems() {
        let pasteboard = NSPasteboard.general
        let items = pasteboard.pasteboardItems!
        for item in items {
            if let string = item.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                ////                if clipboardSavedItems.count==0{
                ////                    let newString = TextType(text: string, hoverAvailable: false)
                ////                    clipboardSavedItems.append(newString)
                ////                    saveData()
                ////                }
                ////                else if  clipboardSavedItems.count > 0 && string != clipboardSavedItems[0].text{
                //                    let newString = TextType(text: string, hoverAvailable: false)
                //                    clipboardSavedItems.insert(newString, at: 0)
                //                    //clipboardSavedItems.append(newString)
                //                    //saveData()
                //                //}
                //                let request = ClipboardItem.fetch()
                //                request.fetchLimit = 1
                //                if clipboardCopyItems.count != 0 {
                //
                //                    let newClipboardItem = ClipboardItem(text: string, context: context)
                //                    clipboardCopyItems.insert(newClipboardItem.text, at: 0)
                //                    PersistenceController.shared.save()
                //                }
                //                else{
                //                    if clipboardCopyItems[0] == string {
                //                        return
                //                    }
                //                    else{
                //                    let managedObjectContext = context
                //                    let textFetchRequest = NSFetchRequest<ClipboardItem>(entityName: "ClipboardItem")
                //                do{
                //                    let newTexts = try managedObjectContext.fetch(textFetchRequest)
                //                    print(texts.count)
                //                }
                //                catch{
                //                    print(error)
                //                }
                if texts.count == 0{
                    _ = ClipboardItem(text: string, dateCopied: Date(), context: context)
                    PersistenceController.shared.save()
                }else if texts.first?.text == string {
                    return
                }
                else{
                    _ = ClipboardItem(text: string, dateCopied: Date(), context: context)
                    PersistenceController.shared.save()
                }
            }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ClipboardView()
    }
}



