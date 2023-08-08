//
//  SettingsView.swift
//  aBicycle
//
//  Created by 1 on 8/4/23.
//

import SwiftUI

struct SettingsView: View {
    
    private enum Tabs: Hashable {
        case general
    }
    
    var body: some View {
        TabView {
            SettingsGeneralView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
        .padding(20)
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
    }
    
}

struct SettingsGeneralView: View {
    @State var ConfigAndroidHOME: String = ""
    @State var ConfigEmulatorPath: String = ""
    @State var ConfigADBPath: String = ""
    @State var ConfigAvdmanagerPath: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("提示：如果此处您自定义了emulator和adb路径，会优先使用自定义配置。相反，则使用操作系统环境变量中已配置Android SDK环境变量，")
                .font(.caption)
                .padding(.bottom, 10)
            
            Form {
                TextField(text: $ConfigAvdmanagerPath, prompt: Text("avdmanager绝对路径，输入回车自动保存")) {
                   Text("avdmanager路径")
                }
                .onSubmit {
                    updateChange(key: "ConfigAvdmanagerPath", value: ConfigAvdmanagerPath)
                }
                
                TextField(text: $ConfigEmulatorPath, prompt: Text("emulator绝对路径，输入回车自动保存")) {
                   Text("emulator路径")
                }
                .onSubmit {
                    updateChange(key: "ConfigEmulatorPath", value: ConfigEmulatorPath)
                }
                
                TextField(text: $ConfigADBPath, prompt: Text("adb绝对路径，输入回车自动保存")) {
                   Text("ADB路径")
                }
                .onSubmit {
                    updateChange(key: "ConfigADBPath", value: ConfigADBPath)
                }
            }
        }
        .onAppear() {
            readSetting()
        }
    }
    
    func updateChange(key: String, value: String) {
        print("TextField 内容变化：\(key) \(value)")
        
        if key == "ConfigADBPath" && !isPathValid(value, endsWith: "adb") {
            _ = showAlert(title: "Error", msg: "ADB路径无效", ConfirmBtnText: "")
            return
        }
        
        if key == "ConfigEmulatorPath" && !isPathValid(value, endsWith: "emulator") {
            _ = showAlert(title: "Error", msg: "emulator路径无效", ConfirmBtnText: "")
            return
        }
        
        if key == "ConfigAvdmanagerPath" && !isPathValid(value, endsWith: "avdmanager") {
            _ = showAlert(title: "Error", msg: "avdmanager路径无效", ConfirmBtnText: "")
            return
        }
        
        do {
            let writeResult = try SettingsHandler.writeJsonFile(key: key, value: value)
            if writeResult {
                isChangeAppSettingsValue = true
            }
        } catch {
            _ = showAlert(title: "Error", msg: "保存配置发生错误", ConfirmBtnText: "")
        }
    }
    
    func readSetting() {
        do {
            let fileContent: [String: Any] = try SettingsHandler.readJsonFileAll(defaultValue: [:])
            if !fileContent.isEmpty {
                if let adbPath = fileContent["ConfigADBPath"] as? String {
                    self.ConfigADBPath = adbPath
                }
                if let emualtorPath = fileContent["ConfigEmulatorPath"] as? String {
                    self.ConfigEmulatorPath = emualtorPath
                }
                if let AvdmanagerPath = fileContent["ConfigAvdmanagerPath"] as? String {
                    self.ConfigAvdmanagerPath = AvdmanagerPath
                }
            }
        } catch {
            _ = showAlert(title: "Error", msg: "读取自定义配置发生错误", ConfirmBtnText: "")
        }
    }
}
