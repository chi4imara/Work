import SwiftUI

struct AddManicureView: View {
    @EnvironmentObject var manicureStore: ManicureStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var color = ""
    @State private var salon = ""
    @State private var note = ""
    
    private var canSave: Bool {
        !color.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
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
                        
                        if !canSave {
                            Text("Add at least color and date to save the record")
                                .font(.playfairDisplay(14))
                                .foregroundColor(AppColors.blueText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Record")
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
                    Button("Save") {
                        saveManicure()
                    }
                    .disabled(!canSave)
                    .foregroundColor(canSave ? AppColors.yellowAccent : AppColors.secondaryText)
                    .font(.playfairDisplay(16, weight: .semibold))
                }
            }
        }
    }
    
    private func saveManicure() {
        let newManicure = Manicure(
            date: selectedDate,
            color: color.trimmingCharacters(in: .whitespacesAndNewlines),
            salon: salon.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        manicureStore.addManicure(newManicure)
        dismiss()
    }
}
