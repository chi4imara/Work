import SwiftUI

struct ListView: View {
    @ObservedObject var weatherData: WeatherDataManager
    @ObservedObject var appState: AppStateManager
    @State private var animateList = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if weatherData.weatherEntries.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.md) {
                            ForEach(Array(weatherData.weatherEntries.enumerated()), id: \.element.id) { index, entry in
                                WeatherEntryRow(
                                    entry: entry,
                                    weatherData: weatherData,
                                    appState: appState,
                                    animationDelay: Double(index) * 0.1
                                )
                                .opacity(animateList ? 1.0 : 0.0)
                                .offset(x: animateList ? 0 : -50)
                                .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.05), value: animateList)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animateList = true
            }
        }
        .sheet(isPresented: $appState.showingColorPicker) {
            ColorPickerView(
                weatherData: weatherData,
                appState: appState,
                selectedDate: appState.selectedDate
            )
        }
        .sheet(isPresented: $appState.showingDayDetails) {
            DayDetailsView(
                weatherData: weatherData,
                appState: appState,
                selectedDate: appState.selectedDate
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Days List")
                .font(Font.poppinsBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !weatherData.weatherEntries.isEmpty {
                Text("\(weatherData.weatherEntries.count) days")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColors.cardGradient)
                    .cornerRadius(AppCornerRadius.small)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "doc.text")
                .font(.system(size: 40))
                .foregroundColor(AppColors.primaryOrange)
            
            VStack(spacing: AppSpacing.sm) {
                Text("No colored days yet")
                    .font(Font.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Your list of colored days will appear here")
                    .font(Font.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button("Mark Today") {
                appState.showColorPicker(for: Date())
            }
            .font(AppFonts.headline)
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, AppSpacing.xl)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.primaryOrange)
            .cornerRadius(AppCornerRadius.medium)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
}

struct WeatherEntryRow: View {
    let entry: WeatherEntry
    let weatherData: WeatherDataManager
    let appState: AppStateManager
    let animationDelay: Double
    
    @State private var showingDeleteAlert = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        Button(action: {
            appState.showDayDetails(for: entry.date)
        }) {
            HStack(spacing: AppSpacing.md) {
            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                .fill(entry.weatherColor.swiftUIColor)
                .frame(width: 36, height: 36)
                .shadow(color: entry.weatherColor.swiftUIColor.opacity(0.3), radius: 3, x: 0, y: 1)
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(dateFormatter.string(from: entry.date))
                        .font(Font.poppinsMedium(size: 14))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(entry.weatherColor.displayName) - \(entry.weatherColor.description)")
                        .font(Font.poppinsRegular(size: 11))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardGradient)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(WeatherEntryButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .tint(AppColors.error)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Edit") {
                appState.showColorPicker(for: entry.date)
            }
            .tint(AppColors.primaryOrange)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation(.easeInOut) {
                    weatherData.removeEntry(for: entry.date)
                }
            }
        } message: {
            Text("Delete color for \(dateFormatter.string(from: entry.date))? This action cannot be undone.")
        }
    }
}

struct WeatherEntryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ListView(weatherData: WeatherDataManager(), appState: AppStateManager())
}
