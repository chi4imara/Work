import SwiftUI

struct IdeaCardView: View {
    let idea: Idea
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onToggleFavorite: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingActions = false
    @State private var selectedTag: Tag?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(.nunito(.semiBold, size: 18))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: idea.category.iconName)
                                    .font(.system(size: 12, weight: .medium))
                                Text(idea.category.displayName)
                                    .font(.nunito(.medium, size: 12))
                            }
                            .foregroundColor(AppColors.categoryColor(for: idea.category))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.categoryColor(for: idea.category).opacity(0.2))
                            )
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onToggleFavorite) {
                        Image(systemName: idea.isFavorite ? "star.fill" : "star")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(idea.isFavorite ? .yellow : AppColors.primaryText.opacity(0.6))
                    }
                }
                
                if !idea.description.isEmpty {
                    Text(idea.description)
                        .font(.nunito(.regular, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(3)
                }
                
                if !idea.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(idea.tags, id: \.id) { tag in
                                Button(action: {
                                    selectedTag = tag
                                }) {
                                    Text(tag.name)
                                        .font(.nunito(.medium, size: 11))
                                        .foregroundColor(AppColors.primaryText)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color(hex: tag.color).opacity(0.3))
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    .padding(.horizontal, -15)
                }
                
                HStack {
                    Text(DateFormatter.shortDate.string(from: idea.dateCreated))
                        .font(.nunito(.regular, size: 12))
                        .foregroundColor(AppColors.tertiaryText)
                    
                    Spacer()
                    
                    if idea.dateModified > idea.dateCreated {
                        Text("Modified")
                            .font(.nunito(.medium, size: 10))
                            .foregroundColor(AppColors.tertiaryText)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.elementBackground)
                            )
                    }
                }
            }
            .padding(16)
        }
        .scaleEffect(dragOffset == .zero ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
        .onTapGesture {
            onTap()
        }
        .sheet(item: $selectedTag) { tag in
            TagDetailView(tag: tag)
        }
    }
}

struct SwipeActionIndicator: View {
    let icon: String
    let color: Color
    let side: SwipeSide
    
    enum SwipeSide {
        case left, right
    }
    
    var body: some View {
        HStack {
            if side == .right {
                Spacer()
            }
            
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 60)
            .background(color)
            .clipShape(Circle())
            
            if side == .left {
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}

struct IdeaCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIdea = Idea(
            title: "Mobile App Concept",
            description: "Create a productivity app that combines task management with habit tracking and goal setting.",
            category: .work,
            tags: [
                Tag(name: "startup", color: "#007AFF"),
                Tag(name: "mobile", color: "#34C759"),
                Tag(name: "productivity", color: "#FF9500")
            ],
            notes: "Research competitors first"
        )
        
        VStack {
            IdeaCardView(
                idea: sampleIdea,
                onTap: { print("Tapped") },
                onEdit: { print("Edit") },
                onDelete: { print("Delete") },
                onToggleFavorite: { print("Toggle favorite") }
            )
            .padding()
        }
        .background(AppColors.backgroundGradient)
    }
}
