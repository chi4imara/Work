import SwiftUI

struct SubjectsView: View {
    @ObservedObject var subjectStore: SubjectStore
    @State private var showingAddSubject = false
    @State private var showingDeleteAlert = false
    @State private var subjectToDelete: Subject?
    @State private var editingSubject: Subject?
    @Binding var isShowingSidebar: Bool
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation(.spring()) {
                            isShowingSidebar = true
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.appText)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(AppColors.cardBackground.opacity(0.9))
                                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                            )
                    }
                    .padding(.leading, 20)
                    .opacity(0)
                    .disabled(true)
                    
                    Spacer()
                    
                    Text("My Subjects")
                        .font(.appTitle)
                        .foregroundColor(.appText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddSubject = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .font(.appSubheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.primaryBlue)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                if subjectStore.subjects.isEmpty {
                    EmptySubjectsView {
                        showingAddSubject = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(subjectStore.subjects) { subject in
                                SubjectCard(
                                    subject: subject,
                                    onTap: {
                                        NotificationCenter.default.post(
                                            name: .subjectSelected,
                                            object: subject
                                        )
                                    },
                                    onEdit: {
                                        editingSubject = subject
                                    },
                                    onDelete: {
                                        subjectToDelete = subject
                                        showingDeleteAlert = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingAddSubject) {
            AddEditSubjectView(subjectStore: subjectStore)
        }
        .sheet(item: $editingSubject) { subject in
            AddEditSubjectView(subjectStore: subjectStore, editingSubject: subject)
        }
        .alert("Delete Subject?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let subject = subjectToDelete {
                    subjectStore.deleteSubject(subject)
                }
            }
        } message: {
            Text("All related tasks will be unavailable from this subject.")
        }
    }
}

struct SubjectCard: View {
    let subject: Subject
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var isShowingActions = false
    @State private var isSwiped = false
    
    var body: some View {
        ZStack {
            if dragOffset.width > 0 {
                HStack {
                    Button(action: onEdit) {
                        VStack {
                            Image(systemName: "pencil")
                            Text("Edit")
                                .font(.appCaption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .background(AppColors.primaryBlue)
            } else if dragOffset.width < 0  {
                HStack {
                    Spacer()
                    
                    Button(action: onDelete) {
                        VStack {
                            Image(systemName: "trash")
                            Text("Delete")
                                .font(.appCaption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                }
                .frame(maxHeight: .infinity)
                .background(Color.red)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(subject.name)
                    .font(.appHeadline)
                    .foregroundColor(.appText)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(subject.upcomingHomework) upcoming homework")
                            .font(.appBody)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("\(subject.upcomingTests) upcoming tests")
                            .font(.appBody)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .offset(x: dragOffset.width, y: 0)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onChanged { value in
                        withAnimation(.interactiveSpring(response: 0.3)) {
                            dragOffset.width = value.translation.width
                            if abs(dragOffset.width) > 120 {
                                dragOffset.width = dragOffset.width > 0 ? 120 : -120
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width > 80 {
                                dragOffset.width = 120
                                isSwiped = true
                                onEdit()
                                resetCard()
                            } else if value.translation.width < -80 {
                                dragOffset.width = -120
                                isSwiped = true
                                onDelete()
                                resetCard()
                            } else {
                                resetCard()
                            }
                        }
                    }
            )
            .onTapGesture {
                if isSwiped {
                    resetCard()
                } else {
                    onTap()
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func resetCard() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            dragOffset = .zero
            isSwiped = false
        }
    }
}

struct EmptySubjectsView: View {
    let onAddSubject: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 80))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 16) {
                Text("No subjects yet")
                    .font(.appHeadline)
                    .foregroundColor(.appText)
                
                Text("Add your first subject to get started!")
                    .font(.appBody)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAddSubject) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Subject")
                }
                .font(.appSubheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.primaryBlue)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}
