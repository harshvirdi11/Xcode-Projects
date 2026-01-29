//
//  ContentView.swift
//  BetterRestApp
//
//  Created by Harsh Virdi on 27/01/26.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0 // 1 if stepper
    //@State private var alertTitle = ""
    //@State private var alertMessage = ""
    //@State private var showAlert: Bool = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.second = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var sleepResults: String{
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch{
            return "Error"
        }
    }
    
    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment: .leading){
                    Text("When do you want to wake up")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading){
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading){
                    Text("Daily coffee intake")
                        .font(.headline)
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<11) {
                            Text("\($0)")
                        }
                    }
                    /*
                     Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount.formatted()) cups", value: $coffeeAmount, in: 0...10, step: 1)
                     */
                }
                
                VStack(alignment: .leading){
                    Text("Your estimated bedtime is:")
                        .font(.headline)
                    Text(sleepResults)
                        .font(.largeTitle)
                        .padding(.top, 5)
                        
                }
                
            }
            .navigationBarTitle("Better Rest")
            /*.toolbar{
                Button{
                    calculateBedTime()
                } label: {
                    Text("Calculate")
                        .foregroundStyle(.blue)
                }
                    
            }
             
            
            .alert(alertTitle, isPresented: $showAlert) {
                Button("Got it") {
                    self.showAlert.toggle()
                }
            } message: {
                Text(alertMessage)
            }
            */
        }
    }
    
    /*
    func calculateBedTime(){
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your bedtime is"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem while calculating your bedtime."
        }
        
        showAlert = true
    }
     */
}

#Preview {
    ContentView()
}
