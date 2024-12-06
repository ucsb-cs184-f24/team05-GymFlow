import SwiftUI

struct ForeCastView: View {
    @ObservedObject var model: ForecastModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Venue Info Section
                VStack(spacing: 10) {
                    Text("UCSB Recreation Center")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

                    Text("\(model.dayInfo)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))

                    HStack(spacing: 20) {
                        Text("Open: \(model.venueOpen)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green.opacity(0.8))

                        Text("Close: \(model.venueClose)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.red.opacity(0.8))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.1))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                // Content Section
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
                
                // Predict Button
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

