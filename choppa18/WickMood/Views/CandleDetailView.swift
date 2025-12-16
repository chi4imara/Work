import SwiftUI

struct CandleDetailView: View {
    let candleId: UUID
    @ObservedObject var candleStore: CandleStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var localIsFavorite: Bool
    
    private var candle: Candle? {
        candleStore.candles.first { $0.id == candleId }
    }
    
    init(candle: Candle, candleStore: CandleStore) {
        self.candleId = candle.id
        self.candleStore = candleStore
        self._localIsFavorite = State(initialValue: candle.isFavorite)
    }
    
    var body: some View {
        Group {
            if let candle = candle {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerView(candle: candle)
                                
                                VStack(spacing: 20) {
                                    candleIconSection(candle: candle)
                                    
                                    basicInfoSection(candle: candle)
                                    
                                    detailsSection(candle: candle)
                                    
                                    impressionSection(candle: candle)
                                    
                                    actionButtonsSection(candle: candle)
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 40)
                            }
                        }
                    }
                    .navigationBarHidden(true)
                }
                .sheet(isPresented: $showingEditView) {
                    if let currentCandle = self.candle {
                        AddEditCandleView(candleStore: candleStore, editingCandle: currentCandle)
                    }
                }
                .alert("Delete Candle", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        if let currentCandle = self.candle {
                            candleStore.deleteCandle(currentCandle)
                        }
                        dismiss()
                    }
                } message: {
                    if let currentCandle = self.candle {
                        Text("Are you sure you want to delete '\(currentCandle.name)'? This action cannot be undone.")
                    }
                }
                .onChange(of: candle.isFavorite) { newValue in
                    localIsFavorite = newValue
                }
                .onAppear {
                    localIsFavorite = candle.isFavorite
                }
            } else {
                Color.clear
                    .onAppear {
                        dismiss()
                    }
            }
        }
    }
    
    private func headerView(candle: Candle) -> some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.textLight)
            }
            
            Spacer()
            
            Text("Scent Details")
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: {
                localIsFavorite.toggle()
                if let currentCandle = self.candle {
                    candleStore.toggleFavorite(for: currentCandle)
                }
            }) {
                Image(systemName: candle.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 24))
                    .foregroundColor(candle.isFavorite ? AppColors.accentPink : AppColors.textLight)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private func candleIconSection(candle: Candle) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryPurple.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(spacing: 4) {
                Text(candle.name)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(candle.brand)
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
    
    private func basicInfoSection(candle: Candle) -> some View {
        HStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Mood")
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .textCase(.uppercase)
                
                Text(candle.mood.rawValue)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryPurple)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.primaryPurple.opacity(0.1))
                    )
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 8) {
                Text("Season")
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .textCase(.uppercase)
                
                Text(candle.season.rawValue)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.primaryBlue.opacity(0.1))
                    )
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func detailsSection(candle: Candle) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            detailCard(
                title: "Scent Notes",
                content: candle.notes.isEmpty ? "No notes added" : candle.notes,
                icon: "leaf.fill",
                iconColor: AppColors.accentGreen
            )
            
            detailCard(
                title: "Date Added",
                content: DateFormatter.shortDate.string(from: candle.dateCreated),
                icon: "calendar",
                iconColor: AppColors.accentOrange
            )
        }
    }
    
    private func impressionSection(candle: Candle) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Impression")
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Text(candle.impression.isEmpty ? "No description added. You can add it later through editing." : candle.impression)
                .font(.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(candle.impression.isEmpty ? AppColors.textLight : AppColors.textPrimary)
                .lineSpacing(4)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                )
        }
    }
    
    private func actionButtonsSection(candle: Candle) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Edit")
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.primaryBlue)
                        .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete")
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.accentPink)
                        .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                )
            }
        }
    }
    
    private func detailCard(title: String, content: String, icon: String, iconColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Text(content)
                .font(.playfairDisplay(size: 14, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    let sampleCandle = Candle(
        name: "Amber Wood",
        brand: "Jo Malone",
        notes: "Amber, sandalwood, musk",
        mood: .cozy,
        season: .autumn,
        impression: "Creates a feeling of warmth and tranquility.",
        isFavorite: true
    )
    
    CandleDetailView(candle: sampleCandle, candleStore: CandleStore())
}
