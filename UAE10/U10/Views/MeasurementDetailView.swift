import SwiftUI

struct MeasurementDetailView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    @Environment(\.presentationMode) var presentationMode
    
    let measurement: Measurement
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        Text(formatDate(measurement.date))
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        Text("Measurement Details")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.white.opacity(0.7))
                    }
                    .padding(.top, 20)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                        DetailMeasurementCard(
                            title: "Weight",
                            value: measurement.weight,
                            unit: "kg",
                            icon: "scalemass"
                        )
                        
                        DetailMeasurementCard(
                            title: "Chest",
                            value: measurement.chest,
                            unit: "cm",
                            icon: "figure.arms.open"
                        )
                        
                        DetailMeasurementCard(
                            title: "Arms",
                            value: measurement.arms,
                            unit: "cm",
                            icon: "figure.strengthtraining.traditional"
                        )
                        
                        DetailMeasurementCard(
                            title: "Shoulders",
                            value: measurement.shoulders,
                            unit: "cm",
                            icon: "figure.flexibility"
                        )
                    }
                    
                    if !measurement.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Notes")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(AppColors.white)
                            
                            Text(measurement.notes)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.white.opacity(0.8))
                                .padding(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppColors.cardGradient)
                                .cornerRadius(15)
                        }
                    }
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit Measurement")
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.buttonGradient)
                            .cornerRadius(25)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete Measurement")
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.error, AppColors.error.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(25)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            AddMeasurementView(measurementToEdit: measurement)
        }
        .alert("Delete Measurement", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                measurementStore.deleteMeasurement(measurement)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this measurement? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct DetailMeasurementCard: View {
    let title: String
    let value: Double
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .light))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 5) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.7))
                
                HStack(alignment: .bottom, spacing: 3) {
                    Text(value > 0 ? String(format: "%.1f", value) : "—")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    if value > 0 {
                        Text(unit)
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.white.opacity(0.6))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationView {
        MeasurementDetailView(measurement: Measurement(
            date: Date(),
            weight: 75.5,
            chest: 95.0,
            arms: 35.5,
            shoulders: 45.0,
            notes: "Feeling strong today!"
        ))
    }
    .environmentObject(MeasurementStore())
}
