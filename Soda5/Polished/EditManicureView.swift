import SwiftUI

struct EditManicureView: View {
    @EnvironmentObject var manicureStore: ManicureStore
    @Environment(\.dismiss) private var dismiss
    
    let manicureId: UUID
    
    @State private var selectedDate: Date = Date()
    @State private var color: String = ""
    @State private var salon: String = ""
    @State private var note: String = ""
    
    private var manicure: Manicure? {
        manicureStore.getManicure(by: manicureId)
    }
    
    private var canSave: Bool {
        !color.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        guard let manicure = manicure else { return false }
        return selectedDate != manicure.date ||
        color != manicure.color ||
        salon != manicure.salon ||
        note != manicure.note
    }
    
    var body: some View {
        Group {
            if let manicure = manicure {
                editContentView(manicure: manicure)
            } else {
                Text("Manicure not found")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .onAppear {
            if let manicure = manicure {
                selectedDate = manicure.date
                color = manicure.color
                salon = manicure.salon
                note = manicure.note
            }
        }
    }
    
    private func editContentView(manicure: Manicure) -> some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Manicure Date")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(AppColors.yellowAccent)
                        }
                        .padding(16)
                        .background(AppColors.backgroundWhite.opacity(0.8))
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nail Color *")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., Burgundy", text: $color)
                                .font(.playfairDisplay(16))
                                .padding(12)
                                .background(AppColors.backgroundGray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(16)
                        .background(AppColors.backgroundWhite.opacity(0.8))
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Salon / Master")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., Anna (NailRoom)", text: $salon)
                                .font(.playfairDisplay(16))
                                .padding(12)
                                .background(AppColors.backgroundGray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(16)
                        .background(AppColors.backgroundWhite.opacity(0.8))
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add your thoughts about this manicure...", text: $note, axis: .vertical)
                                .font(.playfairDisplay(16))
                                .lineLimit(3...6)
                                .padding(12)
                                .background(AppColors.backgroundGray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(16)
                        .background(AppColors.backgroundWhite.opacity(0.8))
                        .cornerRadius(16)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.blueText)
                    .font(.playfairDisplay(16))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .disabled(!canSave || !hasChanges)
                    .foregroundColor((canSave && hasChanges) ? AppColors.yellowAccent : AppColors.secondaryText)
                    .font(.playfairDisplay(16, weight: .semibold))
                }
            }
        }
    }
    
    private func saveChanges() {
        guard var updatedManicure = manicure else { return }
        updatedManicure.date = selectedDate
        updatedManicure.color = color.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedManicure.salon = salon.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedManicure.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        manicureStore.updateManicure(updatedManicure)
        dismiss()
    }
}
