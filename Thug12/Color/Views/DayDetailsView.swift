import SwiftUI

struct DayDetailsView: View {
    @ObservedObject var weatherData: WeatherDataManager
    @ObservedObject var appState: AppStateManager
    var selectedDate: Date
    
    @State private var showingDeleteAlert = false
    @State private var animateContent = false
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    private var weatherEntry: WeatherEntry? {
        weatherData.getEntry(for: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if let entry = weatherEntry {
                    VStack(spacing: AppSpacing.xl) {
                        VStack(spacing: AppSpacing.sm) {
                            Text("Day Details")
                                .font(AppFonts.title)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text(dateFormatter.string(from: selectedDate))
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, AppSpacing.lg)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : -20)
                        
                        Spacer()
                        
                        VStack(spacing: AppSpacing.lg) {
                            ZStack {
                                Circle()
                                    .fill(entry.weatherColor.swiftUIColor)
                                    .frame(width: 200, height: 200)
                                    .shadow(color: entry.weatherColor.swiftUIColor.opacity(0.5), radius: 20, x: 0, y: 0)
                                    .overlay(
                                        Circle()
                                            .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 2)
                                    )
                                
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                entry.weatherColor.swiftUIColor.opacity(0.8),
                                                entry.weatherColor.swiftUIColor
                                            ],
                                            center: .center,
                                            startRadius: 50,
                                            endRadius: 100
                                        )
                                    )
                                    .frame(width: 200, height: 200)
                            }
                            .scaleEffect(animateContent ? 1.0 : 0.5)
                            .opacity(animateContent ? 1.0 : 0.0)
                            
                            VStack(spacing: AppSpacing.sm) {
                                Text("Color: \(entry.weatherColor.displayName)")
                                    .font(AppFonts.title2)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(entry.weatherColor.description)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            .opacity(animateContent ? 1.0 : 0.0)
                            .offset(y: animateContent ? 0 : 20)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: AppSpacing.md) {
                            Button(action: {
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    appState.showColorPicker(for: selectedDate)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Change Color")
                                }
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.md)
                                .background(AppColors.primaryOrange)
                                .cornerRadius(AppCornerRadius.medium)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Entry")
                                }
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.error)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.md)
                                .background(AppColors.cardGradient)
                                .cornerRadius(AppCornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                                        .stroke(AppColors.error.opacity(0.5), lineWidth: 1)
                                )
                            }
                            
                            Button("Close") {
                                dismiss()
                            }
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.vertical, AppSpacing.sm)
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.bottom, AppSpacing.xl)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                    }
                } else {
                    VStack(spacing: AppSpacing.lg) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("No color entry found for this date")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Button("Add Color") {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                appState.showColorPicker(for: selectedDate)
                            }
                        }
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, AppSpacing.xl)
                        .padding(.vertical, AppSpacing.md)
                        .background(AppColors.primaryOrange)
                        .cornerRadius(AppCornerRadius.medium)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateContent = true
            }
        }
        .alert("Delete Color Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                weatherData.removeEntry(for: selectedDate)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismiss()
                }
            }
        } message: {
            Text("Delete color for this day? This action cannot be undone.")
        }
    }
}

#Preview {
    DayDetailsView(
        weatherData: WeatherDataManager(),
        appState: AppStateManager(),
        selectedDate: Date()
    )
}
