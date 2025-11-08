import SwiftUI

struct SeriesCard: View {
    let series: Series
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onTap: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            if offset.width < 0 {
                HStack {
                    Spacer()
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text("Delete")
                                .font(.captionMedium)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.accentRed)
                .cornerRadius(12)
            }
            
            if offset.width > 0 {
                HStack {
                    Button(action: onEdit) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text("Edit")
                                .font(.captionMedium)
                                .foregroundColor(.white)
                        }
                        .frame(width: 80)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryBlue)
                .cornerRadius(12)
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(series.title)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                    
                    Text("Category: \(series.category.displayName)")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Text(series.status.displayName)
                    .font(.captionMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        series.status == .watching ? Color.statusWatching : Color.statusWaiting
                    )
                    .cornerRadius(12)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width > 100 {
                                onEdit()
                            } else if value.translation.width < -100 {
                                showDeleteConfirmation = true
                            }
                            offset = .zero
                        }
                    }
            )
            .onTapGesture {
                onTap()
            }
        }
        .alert("Delete Series", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(series.title)\"?")
        }
    }
}
