import SwiftUI

struct BusyLevelView: View {
    @ObservedObject var model: BusyLevelModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gym Busy Level")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                // Busy level text with gradient border
                ZStack {
                    Text(model.busyLevelText)
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                        .foregroundColor(busyLevelColor(model.busyLevelText))
                        .shadow(color: busyLevelColor(model.busyLevelText).opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [busyLevelColor(model.busyLevelText).opacity(0.6), .white]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 5
                        )
                        .frame(width: 180, height: 180)
                        .shadow(color: busyLevelColor(model.busyLevelText).opacity(0.5), radius: 15, x: 0, y: 5)
                }
                
                // Button to update busy level
                Button(action: {
                    model.fetchBusyLevel()
                }) {
                    Text("Update Busy Level")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            }
            .padding()
        }
    }
    
    private func busyLevelColor(_ busyLevel: String) -> Color {
        switch busyLevel.lowercased() {
        case "quiet":
            return .green
        case "average":
            return .blue
        case "busy":
            return .orange
        case "very busy":
            return .red
        default:
            return .gray
        }
    }
}
