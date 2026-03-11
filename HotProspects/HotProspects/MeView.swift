//
//  MeView.swift
//  HotProspects
//
//  Created by Harsh Virdi on 09/03/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @AppStorage("name") private var name: String = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress: String = "you@yoursite.com"
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                
                TextField("Email Address", text: $emailAddress)
                    .textContentType(.emailAddress)
                
                Section("Your code"){
                    Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                        .frame(width: 300, height: 300)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Your code")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledCIImage = outputImage.transformed(by: transform)

            if let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    MeView()
}
