//
//  SidebarView.swift
//  CDL-convert
//
//  Created by Preston Mohr on 1/27/23.
//

import SwiftUI

struct SidebarView: View {
    var body: some View {
        NavigationView {
            List {
                Text("ASC CDL Info")
                Group {
                    NavigationLink(destination: ContentViewInformation()) {
                        Label("Background", systemImage: "info.circle")
                    }
                    NavigationLink(destination: ContentViewColorScience()) {
                        Label("Color Science", systemImage: "camera.aperture")
                    }
                }
                Divider()
                Text("ASC CDL Services")
                Group {
                    NavigationLink(destination: ContentViewGenerateCDL()) {
                        Label("Generate", systemImage: "plus.circle")
                    }
                    NavigationLink(destination: ContentViewConvertCDL()) {
                        Label("Convert", systemImage: "arrow.left.arrow.right.circle")
                    }
                    NavigationLink(destination: ContentViewBatchConvert()) {
                        Label("Batch Convert", systemImage: "circle.hexagonpath")
                    }
                    NavigationLink(destination: ContentViewEDLConvert()) {
                        Label("Process EDL (beta)", systemImage: "list.bullet.circle")
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .listStyle(SidebarListStyle())
            .navigationTitle("Services")
            
            //Set Sidebar Width (and height)
            .frame(minWidth: 150, minHeight: 300, idealHeight: 600)
            .toolbar{
                //Toggle Sidebar Button
                ToolbarItem(placement: .navigation){
                    Button(action: toggleSidebar, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
            }
            //Default View on Mac
            ContentViewGenerateCDL()
        }
    }
}

// Toggle Sidebar Function
func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}

/*
struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
*/
