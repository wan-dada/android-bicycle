//
//  EmulatorView.swift
//  aBicycle
//
//  Created by 1 on 8/3/23.
//

import SwiftUI

import SwiftUI

struct DeviceItem: Identifiable {
    let name: String
    let id = UUID().uuidString
}


struct EmulatorView: View {
    @State var avdsList: [DeviceItem] = []
    
    @State private var selectedItemId: String = ""
    @State private var selectedItem: String = ""
    @State private var hoverItemId: String = ""
    @State private var hoverItem: String = ""
    
    @State private var activeEmulatorList: [String] = []
    
    var body: some View {
        ScrollView {
            emulator_top_view
            
            if avdsList.isEmpty {
                EmptyView(text: "No Emulator")
            }
            
            if (avdsList.count != 0) {
                show_emulator_list
                    .padding(.horizontal, 10)
            }
        }
        .onAppear() {}
        .task {
            getEmulatorList()
        }
        .contextMenu {
            contextMenu_view
        }
    }
    
    // 右键菜单
    var contextMenu_view: some View {
        Section {
            Button("Refresh Device") {
                getEmulatorList()
            }
            Divider()
        }
    }
    
    var emulator_top_view: some View {
        HStack() {
            Spacer()
        }
    }
    
    var show_emulator_list: some View {
        ForEach(avdsList) { item in
            HStack() {
                Label("", systemImage: "circle.fill")
                    .font(.caption2)
                    .labelStyle(.iconOnly)
                    .foregroundColor(self.activeEmulatorList.contains(item.name) ? Color.green : Color.clear)
                Image("android")
                    .resizable()
                    .frame(width: 24, height: 24)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.body)
                    //Text("Android 10")
                    //    .font(.caption)
                    //    .padding([.top], 0.1)
                }
                Spacer()
                HStack {
                    if self.activeEmulatorList.contains(item.name) {
                        button_view_for_stop
                    } else {
                        button_view_for_start
                    }
                    //button_view_for_edit
                }
                .padding(.horizontal, 15)
            }
            .frame(height: 45)
            .background(hoverItemId == item.id ? Color.gray.opacity(0.1) : Color.clear)
            .background(selectedItem == item.name  ? Color.cyan.opacity(0.05) : Color.clear)
            .cornerRadius(3)
            .onHover { isHovered in
                hoverItemId = isHovered ? item.id : ""
                hoverItem = isHovered ? item.name : ""
            }
            .onTapGesture {
                selectedItem = item.name
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
    
    var button_view_for_start: some View {
        Button(action: bootEmulator ) {
            Label("start_emulator", systemImage: "play.fill")
                .font(.title3)
                .labelStyle(.iconOnly)
                .frame(width: 45, height: 45)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        
    }
    
    var button_view_for_stop: some View {
        Button(action: {
            Task {
                await killEmulator()
            }
        }) {
            Label("stop_emulator", systemImage: "stop.circle.fill")
                .font(.title3)
                .labelStyle(.iconOnly)
                .frame(width: 45, height: 45)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
//    var button_view_for_edit: some View {
//        Button(action: clickEditEmulator) {
//            Label("edit_emulator", systemImage: "pencil")
//                .font(.title3)
//                .labelStyle(.iconOnly)
//        }
//        .buttonStyle(.plain)
//        .padding(.horizontal, 10)
//    }
    
    // 获取模拟器列表
    func getEmulatorList() {
        Task(priority: .medium) {
            do {
                let output = try await AndroidEmulatorManager.getEmulatorList()
                self.avdsList = []
                if !output.isEmpty {
                    for i in output {
                        avdsList.append(DeviceItem(name: i))
                    }
                    await getStartedEmulator(allEmulator: output)
                }
            } catch let error {
                let msg = getErrorMessage(etype: error as! EmulatorError)
                showAlertOnlyPrompt(title: "Error", msg: msg)
            }
        }
    }
    
    // 获取激活的模拟器列表
    func getStartedEmulator(allEmulator: [String]) async {
        do {
            self.activeEmulatorList = try await AndroidEmulatorManager.getActiveEmulatorList(EmulatorList: allEmulator)
        } catch let error {
            let msg = getErrorMessage(etype: error as! EmulatorError)
            showAlertOnlyPrompt(title: "Error", msg: msg)
        }
    }
    
    // 模拟器：启动
    func bootEmulator() {
        if (self.hoverItem == "") {
            return
        }
        let avdName = self.hoverItem
        AndroidEmulatorManager.startEmulator(emulatorName: avdName) { success, error in
            if success {
                activeEmulatorList.append(avdName)
            } else if let error = error {
                let msg = getErrorMessage(etype: error as! EmulatorError)
                showAlertOnlyPrompt(title: "Error", msg: msg)
            }
        }
    }
    
    // 模拟器：停止杀死模拟器
    func killEmulator() async {
        if (self.hoverItem == "") {
            return
        }
        let avdName = self.hoverItem
        do {
            let output = try await AndroidEmulatorManager.killEmulator(emulatorName: avdName)
            if output == true {
                activeEmulatorList.removeAll { element in
                    return element == avdName
                }
            }
        } catch {
            let msg = getErrorMessage(etype: error as! EmulatorError)
            showAlertOnlyPrompt(title: "Error", msg: msg)
        }
    }
}
