//
//  ContentView.swift
//  CoreData+MVVM
//
//  Created by Ricardo on 06/09/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel = ContactsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.contacts) { contact in
                    NavigationLink {
                        Text("Item at \(contact.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(contact.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: viewModel.deleteContacts)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: viewModel.addContact) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


extension ContentView {
    class ContactsViewModel: ObservableObject {
        
        let container: NSPersistentContainer
        @Published var contacts: [Contact] = []
        
        
        init() {
            container = NSPersistentContainer(name: "CoreData_MVVM")
            container.loadPersistentStores { description, error in
                if let error = error {
                    print("Error loading Core Data. \(error)")
                }
            }
            fetchContacts()
        }
        
        func fetchContacts(){
            let request = NSFetchRequest<Contact>(entityName: "Contact")
            
            do {
                contacts = try container.viewContext.fetch(request)
            } catch let error {
                print("Error fectching. \(error)")
            }
            
        }
        
        func addContact() {
            print("Hello")
            withAnimation {
                let newContact = Contact(context: container.viewContext)
                newContact.timestamp = Date()
                saveData()
            }
        }
        
        func saveData(){
            do{
                try container.viewContext.save()
                fetchContacts() // contacts var is updated
            } catch let error {
                print("Error saving. \(error)")
            }
        }
        
        func deleteContacts(offsets: IndexSet) {
            withAnimation {
                offsets.map { contacts[$0] }.forEach(container.viewContext.delete)
                saveData()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
