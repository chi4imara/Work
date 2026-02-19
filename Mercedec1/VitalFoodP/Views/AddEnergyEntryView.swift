import SwiftUI

struct AddEnergyEntryView: View {
    @ObservedObject var viewModel: EnergyViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Energy Level")
                                .font(FontManager.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            VStack(spacing: 12) {
                                Text("\(viewModel.currentEnergyLevel)/10")
                                    .font(FontManager.ubuntu(32, weight: .bold))
                                    .foregroundColor(ColorTheme.accentText)
                                
                                Slider(
                                    value: Binding(
                                        get: { Double(viewModel.currentEnergyLevel) },
                                        set: { viewModel.currentEnergyLevel = Int($0) }
                                    ),
                                    in: 1...10,
                                    step: 1
                                )
                                .accentColor(ColorTheme.primaryYellow)
                                
                                HStack {
                                    Text("Low")
                                        .font(FontManager.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.secondaryText)
                                    Spacer()
                                    Text("High")
                                        .font(FontManager.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Current Mood")
                                .font(FontManager.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(MoodType.allCases, id: \.self) { mood in
                                    MoodSelectionButton(
                                        mood: mood,
                                        isSelected: viewModel.currentMood == mood,
                                        action: { viewModel.currentMood = mood }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Note (Optional)")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("How are you feeling?", text: $viewModel.currentNote, axis: .vertical)
                                .font(FontManager.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .lineLimit(3...6)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.addEnergyEntry()
                            dismiss()
                        }) {
                            Text("Save Entry")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(ColorTheme.buttonBackground)
                                .cornerRadius(25)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Add Energy Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MoodSelectionButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : mood.color)
                
                Text(mood.rawValue)
                    .font(FontManager.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? .white : ColorTheme.primaryText)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(isSelected ? mood.color : ColorTheme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(mood.color, lineWidth: isSelected ? 0 : 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

#Preview {
    AddEnergyEntryView(viewModel: EnergyViewModel())
}
