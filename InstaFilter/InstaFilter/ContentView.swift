//
//  ContentView.swift
//  InstaFilter
//
//  Created by Harsh Virdi on 03/03/26.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var filterIntensity: Double = 0.5
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem){
                    if let processedImage{
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else{
                        ContentUnavailableView("No Image selected", systemImage: "photo.badge.plus", description: Text("click here to add an image"))
                    }
                }
                Spacer()
                
                HStack{
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                }
                
                HStack{
                    Button("Change filter", action: changeFilter)
                }
                Spacer()
            }
            .navigationTitle("InstaFilter")
            .padding([.horizontal,.bottom])
        }
    }
    
    func changeFilter(){
        
    }
}

#Preview {
    ContentView()
}
