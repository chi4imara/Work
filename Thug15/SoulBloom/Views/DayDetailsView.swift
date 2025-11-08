import SwiftUI

struct DayDetailsView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let date: Date
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var entry: GratitudeEntry? {
        viewModel.getEntry(for: date)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            GridPatternView()
                .opacity(0.1)
            
            if let entry = entry {
                VStack {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            dateHeaderView
                                .padding(.top, 8)
                            
                            gratitudeEntriesView(entry: entry)
                            
                            Spacer(minLength: 50)
                        }
                        .padding(.horizontal, 15)
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(ColorTheme.warningRed)
                    
                    Text("Entry not found")
                        .font(FontManager.title)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Button("Go Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(ColorTheme.buttonBackground)
                    )
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            NavigationView {
                NewEntryView(viewModel: viewModel, selectedDate: date, existingEntry: entry)
            }
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
        } message: {
            Text("Delete entry for \(entry?.dateString ?? "this date")? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(FontManager.callout)
                .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Text("Day Details")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Menu {
                    Button("Edit", action: {
                        showingEditView = true
                    })
                    
                    Button("Delete", role: .destructive, action: {
                        showingDeleteAlert = true
                    })
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(ColorTheme.cardBackground)
                        )
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 15)
            
            Divider()
                .frame(maxWidth: .infinity)
                .overlay {
                    Color.white
                }
        }
        .padding(.bottom, -8)
    }
    
    private var dateHeaderView: some View {
        VStack(spacing: 8) {
            Text(dateString)
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .multilineTextAlignment(.center)
            
            Rectangle()
                .fill(ColorTheme.accentYellow)
                .frame(width: 50, height: 2)
                .cornerRadius(1)
        }
        .padding(.vertical, 8)
    }
    
    private func gratitudeEntriesView(entry: GratitudeEntry) -> some View {
        VStack(spacing: 15) {
            GratitudeDisplayCard(
                number: "1",
                text: entry.firstGratitude,
                color: ColorTheme.accentOrange
            )
            
            GratitudeDisplayCard(
                number: "2",
                text: entry.secondGratitude,
                color: ColorTheme.accentYellow
            )
            
            GratitudeDisplayCard(
                number: "3",
                text: entry.thirdGratitude,
                color: ColorTheme.successGreen
            )
        }
    }
    
    private func deleteEntry() {
        viewModel.deleteEntry(for: date)
        presentationMode.wrappedValue.dismiss()
    }
}

struct GratitudeDisplayCard: View {
    let number: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 24, height: 24)
                
                Text(number)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Gratitude #\(number)")
                    .font(FontManager.caption2)
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(text)
                    .font(FontManager.callout)
                    .foregroundColor(ColorTheme.primaryText)
                    .lineSpacing(1)
            }
            
            Spacer()
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        DayDetailsView(
            viewModel: GratitudeViewModel(),
            date: Date()
        )
    }
}
