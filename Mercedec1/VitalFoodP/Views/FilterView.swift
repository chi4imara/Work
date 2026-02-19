import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Mood")
                                .font(FontManager.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(MoodType.allCases, id: \.self) { mood in
                                    MoodFilterButton(
                                        mood: mood,
                                        isSelected: viewModel.selectedMoodFilter == mood,
                                        action: {
                                            if viewModel.selectedMoodFilter == mood {
                                                viewModel.selectedMoodFilter = nil
                                            } else {
                                                viewModel.selectedMoodFilter = mood
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Max Cooking Time")
                                .font(FontManager.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach([15, 30, 60], id: \.self) { time in
                                    TimeFilterButton(
                                        time: time,
                                        isSelected: viewModel.selectedTimeFilter == time,
                                        action: {
                                            if viewModel.selectedTimeFilter == time {
                                                viewModel.selectedTimeFilter = nil
                                            } else {
                                                viewModel.selectedTimeFilter = time
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.applyFilters()
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MoodFilterButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? ColorTheme.buttonText : mood.color)
                
                Text(mood.rawValue)
                    .font(FontManager.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.buttonText : ColorTheme.primaryText)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(isSelected ? mood.color : ColorTheme.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(mood.color, lineWidth: isSelected ? 0 : 1)
            )
        }
    }
}

struct TimeFilterButton: View {
    let time: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(time)m")
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.buttonText : ColorTheme.primaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(isSelected ? ColorTheme.buttonBackground : ColorTheme.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ColorTheme.primaryYellow, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

#Preview {
    FilterView(viewModel: HomeViewModel())
}
