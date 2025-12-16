import SwiftUI

struct WeekPlanView: View {
    @StateObject private var viewModel = WeekPlanViewModel()
    @State private var selectedDay: WeekDay?
    
    var body: some View {
        ZStack {
            AppColors.mainBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Week Plan")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: { viewModel.clearPlan() }) {
                            Text("Clear Plan")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.primaryPurple)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(AppColors.primaryYellow)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.outfits.isEmpty {
                    EmptyStateView(
                        icon: "calendar",
                        title: "No Outfits Available",
                        description: "Add some outfits first to start planning your week"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(WeekDay.allCases, id: \.self) { day in
                                WeekDayCard(
                                    day: day,
                                    outfit: viewModel.getOutfit(for: day)
                                ) {
                                    selectedDay = day
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedDay) { day in
            OutfitPickerView(
                selectedDay: day,
                currentOutfit: viewModel.getOutfit(for: day),
                availableOutfits: viewModel.outfits
            ) { outfit in
                viewModel.setOutfit(for: day, outfit: outfit)
                selectedDay = nil
            }
        }
    }
}

struct WeekDayCard: View {
    let day: WeekDay
    let outfit: Outfit?
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.light)
            onTap()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: outfit != nil ? 
                                    [AppColors.primaryYellow.opacity(0.3), AppColors.primaryPurple.opacity(0.2)] :
                                    [AppColors.cardBackground, AppColors.cardBackground.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Text(day.rawValue)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(outfit != nil ? AppColors.primaryYellow : AppColors.secondaryText)
                }
                
                if let outfit = outfit {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(outfit.name)
                            .font(.ubuntu(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            Text(outfit.mood.displayName)
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(AppColors.primaryPurple)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(AppColors.primaryYellow.opacity(0.3))
                                )
                            
                            Text(outfit.season.displayName)
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.secondaryText)
                            
                            if outfit.isFavorite {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.favoriteHeart)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.secondaryText)
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(AppColors.primaryYellow)
                            
                            Text("Select Outfit")
                                .font(.ubuntu(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        Text("Tap to choose an outfit for \(day.fullName)")
                            .font(.ubuntu(13))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                outfit != nil ?
                                    LinearGradient(
                                        colors: [AppColors.primaryYellow.opacity(0.4), AppColors.primaryPurple.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: outfit != nil ? 1.5 : 1
                            )
                    )
                    .shadow(
                        color: outfit != nil ? 
                            AppColors.primaryYellow.opacity(0.1) : 
                            Color.black.opacity(0.05),
                        radius: outfit != nil ? 8 : 5,
                        x: 0,
                        y: 4
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OutfitPickerView: View {
    let selectedDay: WeekDay
    let currentOutfit: Outfit?
    let availableOutfits: [Outfit]
    let onSelection: (Outfit?) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let current = currentOutfit {
                    VStack(spacing: 16) {
                        Text("Currently Selected")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                        
                        OutfitPickerCard(outfit: current, isSelected: true) {
                            onSelection(nil)
                        }
                        
                        Button("Remove Selection") {
                            onSelection(nil)
                        }
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.errorRed)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground.opacity(0.5))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(availableOutfits) { outfit in
                            OutfitPickerCard(
                                outfit: outfit,
                                isSelected: outfit.id == currentOutfit?.id
                            ) {
                                onSelection(outfit)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .background(AppColors.mainBackgroundGradient.ignoresSafeArea())
            .navigationTitle("Select for \(selectedDay.fullName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
    }
}

struct OutfitPickerCard: View {
    let outfit: Outfit
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(outfit.name)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        Text(outfit.mood.displayName)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.primaryPurple)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(AppColors.primaryYellow.opacity(0.3))
                            )
                        
                        Text(outfit.season.displayName)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                        
                        if outfit.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.favoriteHeart)
                        }
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.successGreen)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.cardBackground.opacity(0.8) : AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.successGreen : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    WeekPlanView()
        .environmentObject(DataManager.shared)
}
