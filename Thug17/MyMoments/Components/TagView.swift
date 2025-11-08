import SwiftUI

enum TagSize {
    case small, medium, large
    
    var fontSize: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 14
        case .large: return 16
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        case .medium: return EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
        case .large: return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        }
    }
}

struct TagView: View {
    let tag: String
    let size: TagSize
    let isSelected: Bool
    let onTap: (() -> Void)?
    
    init(tag: String, size: TagSize = .medium, isSelected: Bool = false, onTap: (() -> Void)? = nil) {
        self.tag = tag
        self.size = size
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            Text(tag)
                .font(.nunitoMedium(size: size.fontSize))
                .foregroundColor(isSelected ? .white : Color.tagColor(for: tag))
                .padding(size.padding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: size.fontSize)
                        .fill(isSelected ? Color.tagColor(for: tag) : Color.tagColor(for: tag).opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: size.fontSize)
                                .stroke(Color.tagColor(for: tag), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(onTap == nil)
    }
}

struct EditableTagView: View {
    let tag: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
            }
            .disabled(true)
            .opacity(0)
            
            Spacer()
            
            Text(tag)
                .font(.nunitoMedium(size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tagColor(for: tag))
        .cornerRadius(14)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            TagView(tag: "work", size: .small)
            TagView(tag: "travel", size: .medium)
            TagView(tag: "family", size: .large)
        }
        
        HStack {
            TagView(tag: "school", size: .medium, isSelected: true)
            TagView(tag: "friends", size: .medium, isSelected: false)
        }
        
        EditableTagView(tag: "removable") {
            print("Remove tag")
        }
    }
    .padding()
}
