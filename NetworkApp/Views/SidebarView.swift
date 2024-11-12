import SwiftUI
import NetworkAppLibrary

struct SidebarView: View {
    @Binding var rules: [Rule]
    @ObservedObject var rulesManager: RulesManager
    @ObservedObject var installationManager: InstallationManager
    @ObservedObject var filterManager: FilterManager
    @State var showSaveButton = false
    
    init(rules: Binding<[Rule]>, rulesManager: ObservedObject<RulesManager>, installationManager: ObservedObject<InstallationManager>, filterManager: ObservedObject<FilterManager>) {
        self._rules = rules
        self._rulesManager = rulesManager
        self._installationManager = installationManager
        self._filterManager = filterManager
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(selection: $rulesManager.filterSelection) {
                Section("Filters") {
                    ForEach(RuleSelection.allCases) { selection in
                        Label(selection.displayName, systemImage: selection.iconName)
                            .tag(selection)
                    }
                }
            }
            .frame(height: 120)
            .scrollDisabled(true)
            
            List{
                Section("Rules") {}
            }
            .scrollDisabled(true)
            .frame(height: 20)
            .buttonStyle(PlainButtonStyle()).disabled(true)
            
            ScrollViewReader { proxy in
                List($rules, id:\.self, selection: $rulesManager.selectedRule) { $rule in
                    Label(rule.title, systemImage: rule.enabled ? "togglepower" : "poweroff")
                        .tag(rule.id)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                self.rulesManager.removeRule(rule)
                            }
                        }
                    EmptyView()
                }
                .onChange(of: rulesManager.selectedRule) { _, newValue in
                    // must be an animation of scroll to item
                    if (newValue?.title == "")
                    {
                        withAnimation {
                            proxy.scrollTo(rulesManager.rules.last, anchor: .bottom)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack (alignment: .leading, spacing: 14) {
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
                        .opacity(0.3)
                    
                    Button(action: {
                        let rule = self.rulesManager.addRule("", false)
                        self.rulesManager.changeSelection(rule: rule)
                        
                    }, label: {
                        Label("Add Rule", systemImage: "plus.circle")
                    })
                    .buttonStyle(.borderless)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 19)
                    
                    Label("Installed", systemImage: installationManager.status.iconName)
                        .help(Text(installationManager.status.tooltip))
                        .padding(.leading, 19)
                    
                    Label("Filter status", systemImage: filterManager.status.iconName)
                        .help(Text(filterManager.status.tooltip))
                        .padding(.leading, 19)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Button(action: {
                            self.rulesManager.saveRules()
                            self.filterManager.restart()
                            self.filterManager.updateStatus()
                        }, label: {
                            Text("Save changes")
                        })
                        .frame(alignment: .leading)
                        
                        Button(action: {
                            self.rulesManager.loadRules()
                        }, label: {
                            Text("Restore changes")
                        })
                        .frame(alignment: .leading)
                    }
                    .frame(alignment: .leading)
                    .padding(.leading, 19)
                    .padding(.bottom, showSaveButton ? 14 : -60)
                    .onChange(of: rulesManager.rulesChanged) { _, newValue in
                        withAnimation {
                            showSaveButton = newValue
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SidebarView_Preview : PreviewProvider {
    @State static var rulesSelection: Rule? = Rule.emptyRule()
    @ObservedObject static var rulesManager = RulesManager()
    @ObservedObject static var installationManager = InstallationManager()
    @ObservedObject static var filterManager = FilterManager()
    
    static var previews: some View {
        SidebarView(rules: .constant(Rule.examples()), rulesManager: _rulesManager, installationManager: _installationManager, filterManager: _filterManager)
        .listStyle(.sidebar)
    }
    
}
#endif
