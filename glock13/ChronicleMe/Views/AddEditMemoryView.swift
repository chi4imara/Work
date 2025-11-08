import SwiftUI

struct AddEditMemoryView: View {
    @ObservedObject var memoryStore: MemoryStore
    let memoryToEdit: Memory?
    
    @Environment(\.dismiss) private var dismiss
    @State private var memoryText: String = ""
    @State private var selectedDate: Date = Date()
    @State private var isImportant: Bool = false
    @State private var showingDatePicker = false
    
    private var isEditing: Bool {
        memoryToEdit != nil
    }
    
    private var canSave: Bool {
        !memoryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        memoryText.count <= 500
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Memory Text")
                                .font(AppFonts.title3)
                                .foregroundColor(AppColors.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryWhite.opacity(0.2), lineWidth: 1)
                                    )
                                    .frame(minHeight: 120)
                                
                                if memoryText.isEmpty {
                                    Text("For example: first working day at a new job")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                                
                                TextEditor(text: $memoryText)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(memoryText.count)/500")
                                    .font(AppFonts.caption)
                                    .foregroundColor(memoryText.count > 500 ? AppColors.deleteRed : AppColors.secondaryText)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Event Date")
                                .font(AppFonts.title3)
                                .foregroundColor(AppColors.primaryText)
                            
                            Button(action: { showingDatePicker = true }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(AppColors.primaryYellow)
                                    
                                    Text(formatDate(selectedDate))
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.primaryWhite.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mark as Important")
                                .font(AppFonts.title3)
                                .foregroundColor(AppColors.primaryText)
                            
                            Button(action: { isImportant.toggle() }) {
                                HStack {
                                    Image(systemName: isImportant ? "star.fill" : "star")
                                        .foregroundColor(isImportant ? AppColors.importantStar : AppColors.secondaryText)
                                    
                                    Text("Important memory")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    if isImportant {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(AppColors.primaryYellow)
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.primaryWhite.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Memory" : "Add Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMemory()
                    }
                    .foregroundColor(canSave ? AppColors.primaryYellow : AppColors.secondaryText)
                    .disabled(!canSave)
                }
            }
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .onAppear {
            if let memory = memoryToEdit {
                memoryText = memory.text
                selectedDate = memory.date
                isImportant = memory.isImportant
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func saveMemory() {
        let trimmedText = memoryText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingMemory = memoryToEdit {
            var updatedMemory = existingMemory
            updatedMemory.text = trimmedText
            updatedMemory.date = selectedDate
            updatedMemory.isImportant = isImportant
            memoryStore.updateMemory(updatedMemory)
        } else {
            let newMemory = Memory(
                text: trimmedText,
                date: selectedDate,
                isImportant: isImportant
            )
            memoryStore.addMemory(newMemory)
        }
        
        dismiss()
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorScheme(.dark)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    AddEditMemoryView(memoryStore: MemoryStore(), memoryToEdit: nil)
}
