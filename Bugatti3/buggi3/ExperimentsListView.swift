import SwiftUI

struct ExperimentsListView: View {
    @ObservedObject var viewModel: ExperimentViewModel
    @State private var showingAddExperiment = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Experiments")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddExperiment = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(Color.theme.buttonText)
                            .frame(width: 44, height: 44)
                            .background(Color.theme.buttonBackground)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                if viewModel.experiments.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "flask")
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.primaryYellow)
                        
                        VStack(spacing: 15) {
                            Text("Here will be your personal experiments.")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("Add the first one to record the result.")
                                .font(.ubuntu(16))
                                .foregroundColor(Color.theme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 40)
                        
                        Button(action: {
                            showingAddExperiment = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add")
                            }
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.theme.buttonBackground)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.experiments) { experiment in
                                ExperimentCard(experiment: experiment)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddExperiment) {
            AddExperimentView(viewModel: viewModel)
        }
        .environmentObject(viewModel)
    }
}

struct ExperimentCard: View {
    let experiment: Experiment
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
                    .lineLimit(2)
                
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
                    .lineLimit(2)
                
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
                    .lineLimit(2)
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
    ExperimentsListView(viewModel: ExperimentViewModel())
}
