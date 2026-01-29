//
//  ContentView.swift
//  UnitConversion
//
//  Created by Harsh Virdi on 22/01/26.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var selectedUnit: String = "Celsius"
    @State private var convertedUnit: String = "Celsius"
    @State private var inputValue: Double = 0.0
    @FocusState private var focus: Bool
    let units: [String] = ["Celsius", "Fahrenheit", "Kelvin"]
    
    func toCelsius() -> Double {
        switch selectedUnit {
        case "Fahrenheit":
            return ((inputValue) - 32) * 5.0 / 9.0
        case "Kelvin":
            return (inputValue) - 273.15
        case "Celsius":
            return inputValue
        default:
            return inputValue
        }
    }
    
    func fromCelsius() -> Double {
        switch convertedUnit {
        case "Fahrenheit":
            return (toCelsius() * 9 / 5) + 32
        case "Kelvin":
            return toCelsius() + 273.15
        case "Celsius":
            return toCelsius()
        default:
            return 0.0
        }
    }
    
    var body: some View {
        NavigationStack{
            Form{
                
                Section("Original Unit"){
                    Picker("Select Unit", selection: $selectedUnit){
                        ForEach(units, id:\.self){ unit in
                            Text(unit)
                        }
                        
                    }
                }
                Section("Enter Value to be converted"){
                    TextField("Eg. 36.5", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focus)
                }
                
                Section("Unit to convert to"){
                    Picker("Select Unit", selection: $convertedUnit){
                        ForEach(units, id:\.self){ unit in
                            Text(unit)
                        }
                        
                    }
                }
                
                Section("Converted result"){
               
                            Text(fromCelsius().formatted() + " \(convertedUnit)")

                        
                    
                }
            }
            .navigationTitle(Text("Unit Conversion"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                if focus{
                    Button("Done"){
                        focus = false
                    }
                }
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}

