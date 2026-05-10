//
//  ScannerView.swift
//  MediCare
//
//  Created by Harsh Virdi on 10/05/26.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String
    @Environment(\.dismiss) var dismiss
    
    // 1. This is where we will create the Apple Camera view
    func makeUIViewController(context: Context) -> DataScannerViewController {
        // We will build the camera here
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        
        scanner.delegate = context.coordinator
        
        return scanner
    }
    
    // 2. This is where we handle any SwiftUI state updates
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: ScannerView
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            // When the user taps a highlighted word, grab the text
            if case .text(let text) = item {
                // 1. Send text back to the main view
                parent.scannedText = text.transcript
                // 2. Close the camera sheet
                parent.dismiss()
            }
        }
    }
}


