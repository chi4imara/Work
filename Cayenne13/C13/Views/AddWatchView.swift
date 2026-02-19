import SwiftUI

struct AddWatchView: View {
    @ObservedObject var viewModel: WatchViewModel
    @State private var watchName = ""
    @State private var purchaseDate = Date()
    @State private var selectedStyle = WatchStyle.classic
    @State private var selectedCondition = WatchCondition.new
    @State private var comment = ""
    @State private var showingWatchAdded = false
    @State private var addedWatch: Watch?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Add Watch")
                        .font(.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Name / Model",
                            text: $watchName,
                            placeholder: "Enter watch name or model"
                        )
                        
                        CustomDatePicker(
                            title: "Purchase Date",
                            date: $purchaseDate
                        )
                        
                        CustomPicker(
                            title: "Style",
                            selection: $selectedStyle,
                            options: WatchStyle.allCases
                        )
                        
                        CustomPicker(
                            title: "Condition",
                            selection: $selectedCondition,
                            options: WatchCondition.allCases
                        )
                        
                        CustomTextEditor(
                            title: "Comment (Optional)",
                            text: $comment,
                            placeholder: "Add any additional notes..."
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: saveWatch) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                            
                            Text("Save")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                        }
                        .foregroundColor(ColorManager.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(28)
                        .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(watchName.isEmpty)
                    .opacity(watchName.isEmpty ? 0.6 : 1.0)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingWatchAdded) {
            if let watch = addedWatch {
                WatchAddedView(watch: watch, isPresented: $showingWatchAdded) {
                    clearForm()
                }
            }
        }
    }
    
    private func saveWatch() {
        let newWatch = Watch(
            name: watchName,
            purchaseDate: purchaseDate,
            style: selectedStyle,
            condition: selectedCondition,
            comment: comment
        )
        
        viewModel.addWatch(newWatch)
        addedWatch = newWatch
        showingWatchAdded = true
    }
    
    private func clearForm() {
        watchName = ""
        purchaseDate = Date()
        selectedStyle = .classic
        selectedCondition = .new
        comment = ""
        addedWatch = nil
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(ColorManager.primaryText)
                .padding()
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct CustomDatePicker: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .colorInvert()
                .labelsHidden()
                .accentColor(ColorManager.lightBlue)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct CustomPicker<T: RawRepresentable & CaseIterable & Hashable>: View where T.RawValue == String {
    let title: String
    @Binding var selection: T
    let options: [T]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option.rawValue) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.rawValue)
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(ColorManager.lightBlue)
                }
                .padding()
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(ColorManager.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(ColorManager.primaryText)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minHeight: 80)
                    .background(Color.clear)
            }
            .background(ColorManager.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    AddWatchView(viewModel: WatchViewModel())
}
