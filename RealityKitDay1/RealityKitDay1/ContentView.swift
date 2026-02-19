//
//  ContentView.swift
//  RealityKitDay1
//
//  Created by Harsh Virdi on 17/02/26.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .ignoresSafeArea()
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        context.coordinator.arView = arView
        
        let mesh = MeshResource.generateBox(size: 0.2)
        
        let material = SimpleMaterial(color: .blue, isMetallic: true)
        
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        entity.generateCollisionShapes(recursive: true)
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: [.any], minimumBounds: [0.2, 0.2]))
        
        //model.position = SIMD3<Float>(0, 0, -2)
        
        anchor.addChild(entity)
        
        arView.scene.addAnchor(anchor)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_ :)))
    
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

}

class Coordinator: NSObject{
     var arView: ARView?
    @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer){
        
        guard let arView = arView else { return }
        
        let location = gestureRecognize.location(in: arView)
        
        if let entity = arView.entity(at: location) as? ModelEntity{
            performJump(on: entity)
        }
        
    }
}

func performJump(on entity: ModelEntity){
    
    let originalTransform = entity.transform
    var jumpTransform = originalTransform
    var landTransform = originalTransform
    
    jumpTransform.translation += [0,0.2,0]
    
    let jumpRotation = simd_quaternion(Float.pi, [0,1,0])
    jumpTransform.rotation = jumpRotation
    
    let landRotation = simd_quaternion(Float.pi*2, [0,1,0])
    landTransform.rotation = landRotation
    
    let newColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    let newMaterial = SimpleMaterial(color: newColor, isMetallic: true)
    
    entity.model?.materials = [newMaterial]
    
    entity.move(to: jumpTransform, relativeTo: entity.parent, duration: 0.4, timingFunction: .easeInOut)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    
        entity.move(to: landTransform, relativeTo: entity.parent, duration: 0.4, timingFunction: .easeInOut)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            entity.transform.rotation = simd_quaternion(0, [0, 1, 0])
        }
    }
}

#Preview {
    ContentView()
}
