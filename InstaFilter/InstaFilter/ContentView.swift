//
//  ContentView.swift
//  InstaFilter
//
//  Created by Harsh Virdi on 03/03/26.


import SwiftUI
import PhotosUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var filterIntensity: Double = 0.5
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Image selected", systemImage: "photo.badge.plus", description: Text("click here to add an image"))
                    }
                }
                .onChange(of: selectedItem, loadImage)
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                }
                
                HStack {
                    Button("Change filter", action: changeFilter)
                }
                Spacer()
            }
            .navigationTitle("InstaFilter")
            .padding([.horizontal,.bottom])
        }
    }
    
    func changeFilter() {
        
    }
    
    func loadImage() {
        Task {
            guard let selectedItem else { return }
            guard let imageData = try? await selectedItem.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            applyProcessing()
        }
    }
    
    func applyProcessing(){
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
