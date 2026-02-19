import SwiftUI

struct EnergySelectionView: View {
    @ObservedObject var viewModel: TodayViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLevels: Set<EnergyLevel> = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("How are you feeling?")
                            .font(FontManager.bold(size: 24))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Text("Select 1-3 energy levels that describe your current state")
                            .font(FontManager.regular(size: 16))
                            .foregroundColor(ColorManager.darkGray.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        ForEach(EnergyLevel.allCases, id: \.self) { level in
                            EnergyLevelCard(
                                level: level,
                                isSelected: selectedLevels.contains(level)
                            ) {
                                toggleSelection(level)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: saveSelection) {
                        HStack {
                            Text("Save Selection")
                                .font(FontManager.medium(size: 18))
                                .foregroundColor(.white)
                            
                            if !selectedLevels.isEmpty {
                                Text("(\(selectedLevels.count))")
                                    .font(FontManager.regular(size: 16))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            selectedLevels.isEmpty ?
                            AnyShapeStyle(ColorManager.lightGray) :
                                AnyShapeStyle(ColorManager.buttonGradient)
                        )
                        .cornerRadius(28)
                        .shadow(
                            color: selectedLevels.isEmpty ? .clear : ColorManager.primaryBlue.opacity(0.3),
                            radius: 8, x: 0, y: 4
                        )
                    }
                    .disabled(selectedLevels.isEmpty)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 30)
                }
            }
            .background(ColorManager.backgroundGradient.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                }
            }
        }
        .onAppear {
            selectedLevels = Set(viewModel.selectedEnergyLevels)
        }
    }
    
    private func toggleSelection(_ level: EnergyLevel) {
        if selectedLevels.contains(level) {
            selectedLevels.remove(level)
        } else if selectedLevels.count < 3 {
            selectedLevels.insert(level)
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func saveSelection() {
        viewModel.selectEnergyLevels(Array(selectedLevels))
        dismiss()
    }
}

struct EnergyLevelCard: View {
    let level: EnergyLevel
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(level.color.opacity(isSelected ? 0.2 : 0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: level.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(level.color)
                }
                
                Text(level.title)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 2) {
                    ForEach(1...7, id: \.self) { index in
                        Circle()
                            .fill(index <= level.rawValue ? level.color : ColorManager.lightGray)
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? level.color : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: isSelected ? level.color.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 8 : 4,
                x: 0, y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    EnergySelectionView(viewModel: TodayViewModel())
}
