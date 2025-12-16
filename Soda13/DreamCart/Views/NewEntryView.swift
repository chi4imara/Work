import SwiftUI

struct NewEntryView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate = Date()
    @State private var procedureName = ""
    @State private var products = ""
    @State private var notes = ""
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.playfairDisplay(16))
                        .foregroundColor(Color.theme.secondaryText)
                        
                        Spacer()
                        
                        Text("New Entry")
                            .font(.playfairDisplay(32, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveEntry()
                        }
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(Color.theme.primaryBlue)
                        .disabled(procedureName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(12)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Procedure Name")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        TextField("e.g., Morning Skincare", text: $procedureName)
                            .font(.playfairDisplay(16))
                            .padding(12)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Products Used")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        TextField("e.g., Toner, Serum, Moisturizer", text: $products, axis: .vertical)
                            .font(.playfairDisplay(16))
                            .lineLimit(3...6)
                            .padding(12)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        TextField("How did it work? Any observations?", text: $notes, axis: .vertical)
                            .font(.playfairDisplay(16))
                            .lineLimit(2...4)
                            .padding(12)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .alert("Missing Information", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Please enter at least a procedure name to save the entry.")
        }
        .onAppear {
            selectedDate = viewModel.selectedDate
        }
    }
    
    private func saveEntry() {
        let trimmedProcedureName = procedureName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedProcedureName.isEmpty else {
            showingAlert = true
            return
        }
        
        let newEntry = BeautyEntry(
            date: selectedDate,
            procedureName: trimmedProcedureName,
            products: products.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addEntry(newEntry)
        viewModel.selectDate(selectedDate)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NewEntryView(viewModel: BeautyDiaryViewModel())
}
