import SwiftUI

struct ForeCastView: View {
    @ObservedObject var model: ForecastModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Display venue and day info
                VStack {
                    Text(model.venueName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Day: \(model.dayInfo)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Open: \(model.venueOpen)")
                            .foregroundColor(.white)
                            .font(.caption)
                        Text("Close: \(model.venueClose)")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                }
                
                if model.hourAnalysis.isEmpty {
                    Text("Press Predict to fetch data")
                        .foregroundColor(.white)
                        .italic()
                } else {
                    ScrollView(.horizontal) {
                        HistogramView(data: model.hourAnalysis)
                            .frame(height: 300)
                            .padding(.horizontal)
                    }
                }
                
                Button(action: {
                    model.fetchDayForecast()
                }) {
                    Text("Predict")
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
}

