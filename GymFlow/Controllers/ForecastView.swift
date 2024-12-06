import SwiftUI

struct ForeCastView: View {
    @ObservedObject var model: ForecastModel
    
    var body: some View {
        ZStack {
            // Set the background to white
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Display venue and day info
                VStack {
//                    Text(model.venueName)
                    Text("Today's Forecast")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(.black)
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.black)  // Changed to black for better contrast
                
                    Text("Day: \(model.dayInfo)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                
                    HStack {
                        Text("Open: \(model.venueOpen)")
                            .foregroundColor(.black)
                            .font(.caption)
                        Text("Close: \(model.venueClose)")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                
                if model.hourAnalysis.isEmpty {
                    Text("Press Predict to fetch data")
                        .foregroundColor(.black)  // Changed to black for better contrast
                        .italic()
                } else {
                    ScrollView(.horizontal) {
                        HistogramView(data: model.hourAnalysis)
                            .frame(height: 300)
                            .padding(.horizontal)
                    }
                }
                
//                Button(action: {
//                    model.fetchDayForecast()
//                }) {
//                    Text("Predict")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 200)
//                        .background(Color.blue)
//                        .cornerRadius(15)
//                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
//                }
            }
            .onAppear {
                model.fetchDayForecast()
            }
            .padding()
        }
    }
}
