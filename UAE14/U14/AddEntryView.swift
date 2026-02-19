import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: PullUpViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var count = ""
    @State private var comment = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    headerView
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            formView
                            
                            saveButton
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(AppColors.secondaryText)
            .font(.ubuntu(16))
            
            Spacer()
            
            Text("New Entry")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button("Cancel") {
                dismiss()
            }
            .opacity(0)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Date")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .colorScheme(.dark)
                    .padding(12)
                    .cardStyle()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Number of Pull-ups")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                TextField("Enter count", text: $count)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .keyboardType(.numberPad)
                    .padding(12)
                    .cardStyle()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Comment (Optional)")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                TextField("Add a comment", text: $comment, axis: .vertical)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(3...6)
                    .padding(12)
                    .cardStyle()
            }
        }
    }
    
    private var saveButton: some View {
        Button {
            saveEntry()
        } label: {
            Text("Save")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.primaryButton)
                .cornerRadius(8)
        }
        .disabled(count.isEmpty)
        .opacity(count.isEmpty ? 0.6 : 1.0)
    }
    
    private func saveEntry() {
        guard let pullUpCount = Int(count), pullUpCount > 0 else {
            alertMessage = "Please enter a valid number of pull-ups"
            showingAlert = true
            return
        }
        
        let newEntry = PullUpEntry(
            date: selectedDate,
            count: pullUpCount,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addEntry(newEntry)
        dismiss()
    }
}

#Preview {
    AddEntryView(viewModel: PullUpViewModel())
}
