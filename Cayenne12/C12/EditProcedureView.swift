import SwiftUI

struct EditProcedureView: View {
    let procedure: Procedure
    @ObservedObject var viewModel: ProceduresViewModel
    let onDismiss: () -> Void
    
    @State private var selectedDate: Date
    @State private var selectedType: ProcedureType
    @State private var products: String
    @State private var comment: String
    @State private var showingDatePicker = false
    @State private var showingTypePicker = false
    
    init(procedure: Procedure, viewModel: ProceduresViewModel, onDismiss: @escaping () -> Void) {
        self.procedure = procedure
        self.viewModel = viewModel
        self.onDismiss = onDismiss
        
        _selectedDate = State(initialValue: procedure.date)
        _selectedType = State(initialValue: procedure.type)
        _products = State(initialValue: procedure.products)
        _comment = State(initialValue: procedure.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            Button(action: { showingDatePicker = true }) {
                                HStack {
                                    Text(selectedDate, style: .date)
                                        .font(.ubuntu(16))
                                        .foregroundColor(AppColors.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .foregroundColor(AppColors.lightBlue)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Procedure Type")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            Button(action: { showingTypePicker = true }) {
                                HStack {
                                    Text(selectedType.displayName)
                                        .font(.ubuntu(16))
                                        .foregroundColor(AppColors.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.lightBlue)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Products Used")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            TextField("e.g., shaving cream, beard oil", text: $products)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            TextField("Add your notes here...", text: $comment, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 40)
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [AppColors.orange, AppColors.orange.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                        }
                        .disabled(products.isEmpty)
                        .opacity(products.isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .foregroundColor(AppColors.lightBlue)
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: $selectedDate)
            }
            .sheet(isPresented: $showingTypePicker) {
                TypePickerSheet(selectedType: $selectedType)
            }
        }
    }
    
    private func saveChanges() {
        var updatedProcedure = procedure
        updatedProcedure.date = selectedDate
        updatedProcedure.type = selectedType
        updatedProcedure.products = products
        updatedProcedure.comment = comment
        
        viewModel.updateProcedure(updatedProcedure)
        onDismiss()
    }
}
