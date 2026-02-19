import SwiftUI

struct AddRecordView: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    let onRecordSaved: (CarRecord) -> Void
    
    @State private var selectedType: RecordType = .wash
    @State private var selectedDate = Date()
    @State private var mileage = ""
    @State private var comment = ""
    @State private var showingDatePicker = false
    @State private var showingTypePicker = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text("Add Record")
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
                
                Button(action: saveRecord) {
                    Text("Save")
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
            }
            .padding(.bottom, 120)
        }
        .sheet(isPresented: $showingTypePicker) {
            TypePickerView(selectedType: $selectedType, isPresented: $showingTypePicker)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate, isPresented: $showingDatePicker)
        }
    }
    
    private func saveRecord() {
        let newRecord = CarRecord(
            type: selectedType,
            date: selectedDate,
            mileage: mileage,
            comment: comment
        )
        
        recordsViewModel.addRecord(newRecord)
        onRecordSaved(newRecord)
        
        selectedType = .wash
        selectedDate = Date()
        mileage = ""
        comment = ""
    }
}

struct TypePickerView: View {
    @Binding var selectedType: RecordType
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ForEach(RecordType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedType = type
                            isPresented = false
                        }) {
                            HStack {
                                Image(systemName: type.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(ColorManager.lightBlue)
                                    .frame(width: 30)
                                
                                Text(type.rawValue)
                                    .font(FontManager.playfairRegular(size: 18))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Spacer()
                                
                                if selectedType == type {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(ColorManager.orange)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorManager.darkBlue.opacity(0.3))
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Select Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(ColorManager.orange)
                }
            }
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
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
                        isPresented = false
                    }
                    .foregroundColor(ColorManager.orange)
                }
            }
        }
    }
}

#Preview {
    AddRecordView(recordsViewModel: CarRecordsViewModel()) { _ in }
}
