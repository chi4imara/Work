import SwiftUI

struct GratitudeDetailView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    let date: Date
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingDeleteAlert = false
    @State private var activeSheet: SheetIdentifier?
    @State private var showingNotFoundAlert = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy (EEEE)"
        return formatter
    }()
    
    private var entry: GratitudeEntry? {
        viewModel.getEntry(for: date)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                if let entry = entry {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(dateFormatter.string(from: entry.date))
                                .font(.playfairDisplay(size: 24, weight: .bold))
                                .foregroundColor(.primaryPurple)
                                .multilineTextAlignment(.center)
                            
                            Text("Your gratitude for this day")
                                .font(.playfairDisplay(size: 16))
                                .foregroundColor(.accentBlue)
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.accentYellow)
                                
                                Text("Your Gratitude")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(.primaryPurple)
                                
                                Spacer()
                            }
                            
                            ScrollView {
                                Text(entry.text)
                                    .font(.playfairDisplay(size: 16))
                                    .foregroundColor(.darkGray)
                                    .lineSpacing(6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 24)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Button(action: { activeSheet = .editEntry(date: date) }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Edit")
                                        .font(.playfairDisplay(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentBlue)
                                .cornerRadius(12)
                                .shadow(color: Color.accentBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Delete")
                                        .font(.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Text("Back to Calendar")
                                    .font(.playfairDisplay(size: 16, weight: .medium))
                                    .foregroundColor(.accentBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.lightGray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                } else {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.accentBlue.opacity(0.6))
                        
                        VStack(spacing: 12) {
                            Text("Entry Not Found")
                                .font(.playfairDisplay(size: 24, weight: .bold))
                                .foregroundColor(.primaryPurple)
                            
                            Text("The gratitude entry for this date could not be found. It may have been deleted.")
                                .font(.playfairDisplay(size: 16))
                                .foregroundColor(.darkGray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        
                        Spacer()
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Text("Back to Calendar")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentBlue)
                                .cornerRadius(12)
                                .shadow(color: Color.accentBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Delete Entry", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteEntry()
                }
            } message: {
                Text("Delete entry for \(dateFormatter.string(from: date))?")
            }
            .sheet(item: $activeSheet) { sheet in
                if case .editEntry(let editDate) = sheet {
                    GratitudeEntryView(viewModel: viewModel, date: editDate)
                }
            }
        }
    }
    
    private func deleteEntry() {
        if let entry = entry {
            viewModel.deleteEntry(entry)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct GratitudeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GratitudeViewModel()
        viewModel.addEntry(text: "Grateful for the beautiful sunrise this morning and the peaceful moment it brought me.", for: Date())
        
        return GratitudeDetailView(viewModel: viewModel, date: Date())
    }
}
