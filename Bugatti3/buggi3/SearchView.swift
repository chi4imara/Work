import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: ExperimentViewModel
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Search")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.theme.secondaryText)
                    
                    TextField("Search experiments...", text: $searchText)
                        .font(.ubuntu(16))
                        .foregroundColor(Color.theme.primaryText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                }
                .padding()
                .background(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.vertical)
                
                if viewModel.experiments.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.primaryYellow)
                        
                        Text("No data to search yet.")
                            .font(.ubuntu(20, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else if searchText.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.primaryYellow)
                        
                        Text("Enter text to search experiments")
                            .font(.ubuntu(18))
                            .foregroundColor(Color.theme.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else {
                    let filteredExperiments = viewModel.experiments.filter { experiment in
                        experiment.contains(searchText)
                    }
                    
                    if filteredExperiments.isEmpty {
                        VStack(spacing: 30) {
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(Color.theme.secondaryText)
                            
                            Text("Nothing found.")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("Try different keywords")
                                .font(.ubuntu(16))
                                .foregroundColor(Color.theme.secondaryText)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredExperiments) { experiment in
                                    SearchResultCard(experiment: experiment, searchText: searchText)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }
                }
            }
        }
        .onChange(of: searchText) { _ in
            viewModel.searchText = searchText
        }
    }
}

struct SearchResultCard: View {
    let experiment: Experiment
    let searchText: String
    @EnvironmentObject var viewModel: ExperimentViewModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Tried:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryYellow)
                    Spacer()
                }
                
                Text(experiment.tried)
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack {
                    Text("Changed:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.accentPink)
                    Spacer()
                }
                
                Text(experiment.changed)
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack {
                    Text("Result:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.accentGreen)
                    Spacer()
                }
                
                Text(experiment.result)
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.theme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .sheet(isPresented: $showingDetail) {
            ExperimentDetailView(experimentId: experiment.id)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    SearchView(viewModel: ExperimentViewModel())
}
