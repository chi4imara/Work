import SwiftUI

struct SkinDiaryView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    @State private var selectedCondition: SkinEntry.SkinCondition = .normal
    @State private var notes = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    entryFormView
                    
                    recentEntriesView
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .alert("Success", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Skin Diary")
                .font(.titleLarge)
                .foregroundColor(ColorManager.primaryText)
            
            Text("Track your skin condition")
                .font(.bodyMedium)
                .foregroundColor(ColorManager.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var entryFormView: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
                Text("How is your skin today?")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(SkinEntry.SkinCondition.allCases, id: \.self) { condition in
                        ConditionButton(
                            condition: condition,
                            isSelected: selectedCondition == condition,
                            action: { selectedCondition = condition }
                        )
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Notes")
                    .font(.bodyLarge)
                    .foregroundColor(ColorManager.primaryText)
                    .fontWeight(.medium)
                
                TextField("How does your skin feel? Any observations...", text: $notes, axis: .vertical)
                    .textFieldStyle(CustomTextFieldStyle())
                    .lineLimit(3...6)
            }
            
            Button(action: saveEntry) {
                Text("Save Entry")
                    .font(.titleSmall)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
            }
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorManager.shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private var recentEntriesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Entries")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            if viewModel.skinEntries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "book.circle")
                        .font(.system(size: 40))
                        .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
                    
                    Text("No entries yet")
                        .font(.bodyMedium)
                        .foregroundColor(ColorManager.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.skinEntries.sorted(by: { $0.date > $1.date }).prefix(10), id: \.id) { entry in
                        SkinEntryCard(entry: entry)
                    }
                }
            }
        }
    }
    
    private func saveEntry() {
        let entry = SkinEntry(
            condition: selectedCondition,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addSkinEntry(entry)
        
        notes = ""
        selectedCondition = .normal
        
        alertMessage = "Skin entry saved successfully!"
        showingAlert = true
    }
}

struct ConditionButton: View {
    let condition: SkinEntry.SkinCondition
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: condition.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : ColorManager.primaryBlue)
                
                Text(condition.rawValue)
                    .font(.bodySmall)
                    .foregroundColor(isSelected ? .white : ColorManager.darkText)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected ?
                LinearGradient(
                    gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [ColorManager.cardBackground, ColorManager.cardBackground]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .shadow(color: ColorManager.shadowColor, radius: isSelected ? 5 : 2, x: 0, y: isSelected ? 3 : 1)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct SkinEntryCard: View {
    let entry: SkinEntry
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: entry.condition.icon)
                .font(.system(size: 20))
                .foregroundColor(ColorManager.primaryBlue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.condition.rawValue)
                        .font(.bodyLarge)
                        .foregroundColor(ColorManager.darkText)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(DateFormatter.entryFormatter.string(from: entry.date))
                        .font(.bodySmall)
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                if !entry.notes.isEmpty {
                    Text(entry.notes)
                        .font(.bodyMedium)
                        .foregroundColor(ColorManager.secondaryText)
                        .lineLimit(2)
                }
            }
        }
        .padding(16)
        .background(ColorManager.cardBackground)
        .cornerRadius(12)
        .shadow(color: ColorManager.shadowColor, radius: 3, x: 0, y: 2)
    }
}

extension DateFormatter {
    static let entryFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter
    }()
}

#Preview {
    SkinDiaryView(viewModel: SkinCareViewModel())
}
