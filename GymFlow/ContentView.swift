import SwiftUI

struct ContentView: View {
    @State private var busyLevel = BusyLevel.normal
    @State private var busyPercentage: Double = 0.0
    
    enum BusyLevel: String, CaseIterable {
        case quiet = "Quiet"
        case normal = "Normal"
        case busy = "Busy"
        case veryBusy = "Very Busy"
        
        func nextLevel() -> BusyLevel {
            let allCases = BusyLevel.allCases
            guard let currentIndex = allCases.firstIndex(of: self) else { return .normal }
            let nextIndex = (currentIndex + 1) % allCases.count
            return allCases[nextIndex]
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Gym Busy Level")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(busyLevel.rawValue)
                .font(.system(size: 48))
                .fontWeight(.medium)
                .foregroundColor(busyLevelColor)
            
            Text("\(Int(busyPercentage))% Busy")
                .font(.title)
                .fontWeight(.semibold)
            
            Button(action: {
                updateBusyLevel()
            }) {
                Text("Update Busy Level")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            updateBusyLevel()
        }
    }
    
    var busyLevelColor: Color {
        switch busyLevel {
        case .quiet:
            return .green
        case .normal:
            return .blue
        case .busy:
            return .orange
        case .veryBusy:
            return .red
        }
    }
    
    func updateBusyLevel() {
        // Simulated API call
        fetchBusyPercentage { percentage in
            self.busyPercentage = percentage
            self.busyLevel = getBusyLevelFromPercentage(percentage)
        }
    }
    
    func fetchBusyPercentage(completion: @escaping (Double) -> Void) {
        // Simulated API call with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let randomPercentage = Double.random(in: 0...100)
            completion(randomPercentage)
        }
    }
    
    func getBusyLevelFromPercentage(_ percentage: Double) -> BusyLevel {
        switch percentage {
        case 0..<25:
            return .quiet
        case 25..<50:
            return .normal
        case 50..<75:
            return .busy
        default:
            return .veryBusy
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
