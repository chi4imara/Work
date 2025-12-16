import SwiftUI

struct EditEntryView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    let entry: BeautyEntry
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate: Date
    @State private var procedureName: String
    @State private var products: String
    @State private var notes: String
    @State private var showingAlert = false
    
    init(viewModel: BeautyDiaryViewModel, entry: BeautyEntry) {
        self.viewModel = viewModel
        self.entry = entry
        self._selectedDate = State(initialValue: entry.date)
        self._procedureName = State(initialValue: entry.procedureName)
        self._products = State(initialValue: entry.products)
        self._notes = State(initialValue: entry.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
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
                            Text("Notes")
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
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                    .disabled(procedureName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Missing Information", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Please enter at least a procedure name to save the entry.")
        }
    }
    
    private func saveChanges() {
        let trimmedProcedureName = procedureName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedProcedureName.isEmpty else {
            showingAlert = true
            return
        }
        
        var updatedEntry = entry
        updatedEntry.date = selectedDate
        updatedEntry.procedureName = trimmedProcedureName
        updatedEntry.products = products.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedEntry.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateEntry(updatedEntry)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditEntryView(
        viewModel: BeautyDiaryViewModel(),
        entry: BeautyEntry.sampleEntries[0]
    )
}
