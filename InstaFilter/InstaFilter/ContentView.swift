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
import StoreKit

struct ContentView: View {
    @State private var filterIntensity: Double = 0.5
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters: Bool = false

    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @AppStorage("filterCount") var filterCount: Int = 0
    @Environment(\.requestReview) var requestReview
    
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
                
                if let processedImage {
                    ShareLink(
                        item: processedImage,
                        preview: SharePreview("InstaFilter image", image: processedImage)
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .navigationTitle("InstaFilter")
            .padding([.horizontal,.bottom])
            .confirmationDialog("Filters", isPresented: $showingFilters){
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        if filterCount > 20 {
            requestReview()
        }
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
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
