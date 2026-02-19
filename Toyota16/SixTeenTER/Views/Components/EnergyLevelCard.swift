import SwiftUI

struct EnergyLevelCard: View {
    let energyType: EnergyType
    let isSelected: Bool
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppColors.primaryOrange : AppColors.cardBackground)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? AppColors.primaryOrange : AppColors.separatorColor,
                                    lineWidth: 2
                                )
                        )
                    
                    Image(systemName: energyType.iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                }
                
                Text(energyType.displayName)
                    .font(.ubuntu(.medium, size: 10))
                    .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.tertiaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: AppConstants.shortAnimation), value: isSelected)
    }
}

struct EnergySelectionSheet: View {
    @ObservedObject var viewModel: TodayViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppConstants.largeSpacing) {
                        VStack(spacing: 8) {
                            Text("How are you feeling today?")
                                .font(.ubuntu(.bold, size: AppConstants.titleFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Select 1-3 that best describe your current state")
                                .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                            ForEach(EnergyType.allCases, id: \.self) { energyType in
                                EnergyLevelCard(
                                    energyType: energyType,
                                    isSelected: viewModel.selectedEnergyLevels.contains(energyType)
                                ) {
                                    viewModel.toggleEnergyLevel(energyType)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if !viewModel.selectedEnergyLevels.isEmpty {
                            VStack(spacing: 12) {
                                Text("Selected: \(viewModel.selectedEnergyLevels.count)/3")
                                    .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                                    .foregroundColor(AppColors.primaryOrange)
                                
                                Button {
                                    isPresented = false
                                } label: {
                                    Text("Save Assessment")
                                        .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                        .foregroundColor(AppColors.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: AppConstants.buttonHeight)
                                        .background(AppColors.buttonGradient)
                                        .cornerRadius(AppConstants.mediumCornerRadius)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Energy Assessment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primaryOrange)
                }
            }
        }
    }
}

#Preview {
    EnergyLevelCard(energyType: .energy, isSelected: true)
        .padding()
        .background(AppColors.backgroundGradient)
}
