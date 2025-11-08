import SwiftUI

struct SeriesDetailView: View {
    @ObservedObject var viewModel: SeriesViewModel
    let seriesId: UUID
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    
    private var series: Series? {
        viewModel.series.first { $0.id == seriesId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                if let series = series {
                    VStack(spacing: 0) {
                        HStack {
                            Button("Back") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.bodyLarge)
                            .foregroundColor(.primaryBlue)
                            
                            Spacer()
                            
                            Text("Series Details")
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Text("Back")
                                .font(.bodyLarge)
                                .foregroundColor(.clear)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(spacing: 20) {
                                    VStack(spacing: 12) {
                                        Text(series.title)
                                            .font(.titleLarge)
                                            .foregroundColor(.textPrimary)
                                            .multilineTextAlignment(.center)
                                        
                                        Text(series.status.displayName)
                                            .font(.bodyMedium)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                series.status == .watching ? Color.statusWatching : Color.statusWaiting
                                            )
                                            .cornerRadius(16)
                                    }
                                    
                                    Divider()
                                        .background(Color.lightBlue.opacity(0.5))
                                    
                                    VStack(spacing: 16) {
                                        DetailRow(
                                            icon: "folder",
                                            title: "Category",
                                            value: series.category.displayName
                                        )
                                        
                                        DetailRow(
                                            icon: "calendar",
                                            title: "Added",
                                            value: DateFormatter.shortDate.string(from: series.dateAdded)
                                        )
                                        
                                        if !series.description.isEmpty {
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack {
                                                    Image(systemName: "text.alignleft")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.primaryBlue)
                                                        .frame(width: 20)
                                                    
                                                    Text("Description")
                                                        .font(.titleSmall)
                                                        .foregroundColor(.textPrimary)
                                                    
                                                    Spacer()
                                                }
                                                
                                                Text(series.description)
                                                    .font(.bodyLarge)
                                                    .foregroundColor(.textSecondary)
                                                    .lineLimit(nil)
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }
                                    }
                                }
                                .padding(24)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16))
                                    Text("Edit")
                                        .font(.titleSmall)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.primaryBlue, Color.secondaryBlue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            Button(action: {
                                showingDeleteConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16))
                                    Text("Delete")
                                        .font(.titleSmall)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.accentRed, Color.accentRed.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.accentRed.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                } else {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("Series not found")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Button("Go Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.titleSmall)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.primaryBlue)
                        .cornerRadius(12)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingEditView) {
            AddEditSeriesView(viewModel: viewModel, editingSeries: series)
        }
        .alert("Delete Series", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let series = series {
                    viewModel.deleteSeries(series)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            if let series = series {
                Text("Are you sure you want to delete \"\(series.title)\"? This action cannot be undone.")
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.primaryBlue)
                .frame(width: 20)
            
            Text(title)
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
