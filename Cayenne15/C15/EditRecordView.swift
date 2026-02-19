import SwiftUI

struct EditRecordView: View {
    let record: CarRecord
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    let onDismiss: () -> Void
    
    @State private var selectedType: RecordType
    @State private var selectedDate: Date
    @State private var mileage: String
    @State private var comment: String
    @State private var showingDatePicker = false
    @State private var showingTypePicker = false
    
    init(record: CarRecord, recordsViewModel: CarRecordsViewModel, onDismiss: @escaping () -> Void) {
        self.record = record
        self.recordsViewModel = recordsViewModel
        self.onDismiss = onDismiss
        
        _selectedType = State(initialValue: record.type)
        _selectedDate = State(initialValue: record.date)
        _mileage = State(initialValue: record.mileage)
        _comment = State(initialValue: record.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Text("Edit Record")
                            .font(FontManager.playfairBold(size: 28))
                            .foregroundColor(ColorManager.primaryText)
                            .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Operation Type")
                                    .font(FontManager.playfairMedium(size: 16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Button(action: { showingTypePicker = true }) {
                                    HStack {
                                        Image(systemName: selectedType.icon)
                                            .foregroundColor(ColorManager.lightBlue)
                                        
                                        Text(selectedType.rawValue)
                                            .font(FontManager.playfairRegular(size: 16))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(ColorManager.secondaryText)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ColorManager.darkBlue.opacity(0.3))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                            }
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(FontManager.playfairMedium(size: 16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Button(action: { showingDatePicker = true }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(ColorManager.lightBlue)
                                        
                                        Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                                            .font(FontManager.playfairRegular(size: 16))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(ColorManager.secondaryText)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ColorManager.darkBlue.opacity(0.3))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                            }
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mileage")
                                    .font(FontManager.playfairMedium(size: 16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                HStack {
                                    Image(systemName: "speedometer")
                                        .foregroundColor(ColorManager.lightBlue)
                                    
                                    TextField("Enter current mileage", text: $mileage)
                                        .font(FontManager.playfairRegular(size: 16))
                                        .foregroundColor(ColorManager.primaryText)
                                        .keyboardType(.numberPad)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.darkBlue.opacity(0.3))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                        }
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment (Optional)")
                                    .font(FontManager.playfairMedium(size: 16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                HStack(alignment: .top) {
                                    Image(systemName: "text.bubble")
                                        .foregroundColor(ColorManager.lightBlue)
                                        .padding(.top, 4)
                                    
                                    TextField("Add a comment...", text: $comment, axis: .vertical)
                                        .font(FontManager.playfairRegular(size: 16))
                                        .foregroundColor(ColorManager.primaryText)
                                        .lineLimit(3...6)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.darkBlue.opacity(0.3))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                        }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(FontManager.playfairSemiBold(size: 18))
                                .foregroundColor(ColorManager.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    mileage.isEmpty ? AnyShapeStyle(ColorManager.gray) : AnyShapeStyle(ColorManager.accentGradient)
                                )
                                .cornerRadius(28)
                                .padding(.horizontal, 20)
                        }
                        .disabled(mileage.isEmpty)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .foregroundColor(ColorManager.orange)
                }
            }
        }
        .sheet(isPresented: $showingTypePicker) {
            TypePickerView(selectedType: $selectedType, isPresented: $showingTypePicker)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate, isPresented: $showingDatePicker)
        }
    }
    
    private func saveChanges() {
        var updatedRecord = record
        updatedRecord.type = selectedType
        updatedRecord.date = selectedDate
        updatedRecord.mileage = mileage
        updatedRecord.comment = comment
        
        recordsViewModel.updateRecord(updatedRecord)
        onDismiss()
    }
}

#Preview {
    EditRecordView(
        record: CarRecord(
            type: .wash,
            date: Date(),
            mileage: "124530",
            comment: "Full wash with interior cleaning"
        ),
        recordsViewModel: CarRecordsViewModel()
    ) {}
}
