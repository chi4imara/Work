import SwiftUI

struct NewProcedureView: View {
    @ObservedObject var viewModel: ProceduresViewModel
    
    @State private var selectedDate = Date()
    @State private var selectedType: ProcedureType = .shaving
    @State private var products = ""
    @State private var comment = ""
    @State private var showingDatePicker = false
    @State private var showingTypePicker = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("New Procedure")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
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
                        
                        Button(action: saveProcedure) {
                            Text("Save")
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
                    .padding(.vertical, 20)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate)
        }
        .sheet(isPresented: $showingTypePicker) {
            TypePickerSheet(selectedType: $selectedType)
        }
    }
    
    private func saveProcedure() {
        let procedure = Procedure(
            date: selectedDate,
            type: selectedType,
            products: products,
            comment: comment
        )
        
        viewModel.addProcedure(procedure)
        
        selectedDate = Date()
        selectedType = .shaving
        products = ""
        comment = ""
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .colorScheme(.dark)
                        .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.orange)
                }
            }
        }
    }
}

struct TypePickerSheet: View {
    @Binding var selectedType: ProcedureType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    ForEach(ProcedureType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedType = type
                            dismiss()
                        }) {
                            HStack {
                                Text(type.displayName)
                                    .font(.ubuntu(18))
                                    .foregroundColor(AppColors.white)
                                
                                Spacer()
                                
                                if selectedType == type {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.orange)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedType == type ? AnyShapeStyle(AppColors.cardGradient) : AnyShapeStyle(Color.clear))
                            )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Procedure Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.orange)
                }
            }
        }
    }
}
