import SwiftUI

struct DevicesView: View {
    @StateObject private var viewModel = DevicesViewModel()
    @State private var showingAddDevice = false
    @State private var deviceToEdit: Device?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                
                if viewModel.devices.isEmpty {
                    emptyState
                } else {
                    devicesList
                }
            }
            .bgGradient()
            .sheet(isPresented: $showingAddDevice) {
                AddDeviceView(viewModel: viewModel, deviceToEdit: deviceToEdit)
                    .onDisappear {
                        deviceToEdit = nil
                    }
            }
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Devices")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.mustard)
                
                Text("\(viewModel.devices.count) \(viewModel.devices.count == 1 ? "device" : "devices")")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                showingAddDevice = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: SFSymbols.add)
                        .font(.body.weight(.semibold))
                    Text("Add")
                        .font(.body.weight(.semibold))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.mustard)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "bolt.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.mustard)
            }
            
            Text("No devices added")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            Text("Create an energy passport for your home by adding appliances to track usage")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .fixedSize(horizontal: false, vertical: true)
            
            Button {
                showingAddDevice = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: SFSymbols.add)
                        .font(.body.weight(.semibold))
                    Text("Add first device")
                        .font(.body.weight(.semibold))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.mustard)
                )
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
    
    private var devicesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.devices) { device in
                    DeviceCard(
                        device: device,
                        onEdit: {
                            deviceToEdit = device
                            showingAddDevice = true
                        },
                        onDelete: {
                            viewModel.deleteDevice(device)
                        }
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .animation(.easeInOut(duration: 0.3), value: viewModel.devices.count)
        }
    }
}

#Preview {
    DevicesView()
}

