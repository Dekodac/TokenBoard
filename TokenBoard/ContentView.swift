import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loggedIn: Bool = false
    @State private var totalTokens: Int = 0 // Track total tokens
    
    var body: some View {
            NavigationView {
                if loggedIn {
                    // If logged in, show the main content with navigation bar
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Hello, \(username)!")
                    }
                    .padding()
                    .navigationTitle("Welcome")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Spacer()
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                Spacer()
                                NavigationLink(destination: CreateListView(totalTokens: $totalTokens)) {
                                    Text("My Lists")
                                }
                                Spacer()
                                NavigationLink(destination: TokensView(totalTokens: $totalTokens)) {
                                    Text("My Tokens")
                                }
                                Spacer()
                            }
                        }
                    }
                } else {
                // If not logged in, show the login form
                VStack {
                    Image(systemName: "person.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .padding(.bottom, 30)
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none) // Disable automatic capitalization
                        .disableAutocorrection(true) // Disable autocorrection

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none) // Disable automatic capitalization
                        .disableAutocorrection(true) // Disable autocorrection

                    
                    Button(action: {
                        // For demo purposes, checking login with hardcoded credentials
                        if username == "user" && password == "password" {
                            loggedIn = true
                        }
                    }, label: {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    })
                    .padding()
                }
                .padding()
            }
        }
    }
}

struct CreateListView: View {
    @State private var title: String = ""
    @State private var isComplete: Bool = false
    @Binding var totalTokens: Int // Binding to total tokens
    @State private var createdLists: [CustomList] = [] // Store created lists
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create a List")) {
                    TextField("Title", text: $title)
                    Toggle("Complete", isOn: $isComplete)
                }
                
                Section {
                    Button(action: {
                        // Create a new list and add it to the list of created lists
                        let newList = CustomList(title: title, isComplete: isComplete)
                        createdLists.append(newList)
                        
                        // Clear the fields after creating the list
                        title = ""
                        isComplete = false
                        totalTokens += 1 // Increment tokens
                    }, label: {
                        Text("Submit")
                    })
                }
            }
            .navigationTitle("Create List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: NavigationLink(destination: ListView(lists: $createdLists, totalTokens: $totalTokens)) {
                Text("My Lists")
            })
        }
    }
}

struct CustomList: Identifiable {
    let id = UUID()
    var title: String
    var isComplete: Bool
}

struct ListView: View {
    @Binding var lists: [CustomList]
    @Binding var totalTokens: Int // Binding to total tokens
    @State private var showAlert = false
    @State private var selectedList: CustomList?
    
    var body: some View {
        List {
            ForEach(lists) { list in
                HStack {
                    Text(list.title)
                    Spacer()
                    Button(action: {
                        selectedList = list
                        showAlert = true
                    }, label: {
                        Text("Complete")
                            .foregroundColor(.blue)
                    })
                }
            }
        }
        .navigationBarTitle("My Lists")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("Good job, you get 1 token!"),
                dismissButton: .destructive(Text("OK")) {
                    if let selectedList = selectedList {
                        lists.removeAll(where: { $0.id == selectedList.id })
                    }
                }
            )
        }
    }
}

struct TokensView: View {
    @Binding var totalTokens: Int
    
    var body: some View {
        VStack {
            Text("So far you have \(totalTokens) Tokens!")
                .font(.title)
                .foregroundColor(.blue)
                .padding()
            
            Text("Keep going!")
                .font(.headline)
                .foregroundColor(.green)
                .padding()
        }
        .navigationTitle("My Tokens")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
