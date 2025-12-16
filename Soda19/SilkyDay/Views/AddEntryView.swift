import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: CareJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedType: CareEntryType = .product
    @State private var name: String = ""
    @State private var selectedDate = Date()
    @State private var comment: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        typeSelectionView
                        
                        nameInputView
                        
                        datePickerView
                        
                        commentInputView
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .foregroundColor(AppColors.yellow)
                    .fontWeight(.semibold)
                }
            }
            .alert("Missing Information", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text("Please enter a name and select a type to save the entry.")
            }
        }
    }
    
    private var typeSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Type")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 16) {
                ForEach(CareEntryType.allCases, id: \.self) { type in
                    TypeSelectionButton(
                        type: type,
                        isSelected: selectedType == type
                    ) {
                        selectedType = type
                    }
                }
                Spacer()
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var nameInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            TextField(selectedType == .product ? "Product name" : "Procedure name", text: $name)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var datePickerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .accentColor(AppColors.yellow)
                .colorScheme(.dark)
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var commentInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment (Optional)")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            TextField("Add your thoughts...", text: $comment, axis: .vertical)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                )
                .lineLimit(3...6)
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private func saveEntry() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingAlert = true
            return
        }
        
        let newEntry = CareEntry(
            type: selectedType,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            date: selectedDate,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addEntry(newEntry)
        dismiss()
    }
}

struct TypeSelectionButton: View {
    let type: CareEntryType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
                
                Text(type.displayName)
                    .font(AppFonts.caption)
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.yellow : AppColors.cardBackground.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.yellow : AppColors.yellow.opacity(0.3), lineWidth: 2)
            )
        }
    }
}

#Preview {
    AddEntryView(viewModel: CareJournalViewModel())
}
