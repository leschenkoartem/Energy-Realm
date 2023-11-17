//
//  ContentView.swift
//  EnergyTreck
//
//  Created by Artem Leschenko on 12.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Spacer().frame(height: 130)
                    ForEach(vm.datalist, id: \.time) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                Text(item.taste)
                            }
                            Spacer()
                            VStack {
                                Text("\(Int(item.coffein * item.volume / 100)) mg")
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(Color.main)
                                
                                Text(vm.formatVolumeString(Double(item.volume) / 1000.0))
                            }
                            Image(item.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                                .shadow( color: .white, radius: 1)
                                .frame(width: 50)
                        }.frame(maxWidth: .infinity)
                            .onAppear {
                                print(item)
                            }
                            .padding()
                        .background(Color(.systemGray4))
                        .cornerRadius(12)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { indexSet in
                        let itemsToDelete = indexSet.map { vm.datalist[$0] }
                        withAnimation {
                            vm.deleteItems(with: itemsToDelete)
                        }
                    }
                }
                .listStyle(.plain)
            }
            
            VStack {
                ModalView()
                    .padding(.top, 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .frame(height: UIScreen.main.bounds.height < 680 ? 120: 120)
                    .gesture(
                            DragGesture()
                                .onEnded { gesture in
                                    // Check if the user swiped upward
                                    if gesture.translation.height < 0 {
                                        withAnimation {
                                            vm.pickedView = .already
                                        }
                                    } else {
                                        withAnimation {
                                            vm.pickedView = .custom
                                        }
                                    }
                                }
                        )
                
                Spacer()
                
            }.offset(y: -20)
        }
        .onAppear {
            vm.updateData()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}


struct ModalView: View {
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 20) {
                Circle()
                    .frame(width: vm.pickedView == .custom ? 7: 4)
                    .foregroundColor(vm.pickedView == .custom ? .white: Color(.systemGray2))
                    .animation(.easeInOut(duration: 0.3), value: vm.pickedView)

                Circle()
                    .frame(width: vm.pickedView == .already ? 7: 4)
                    .foregroundColor(vm.pickedView == .already ? .white: Color(.systemGray2))
                    .animation(.easeInOut(duration: 0.3), value: vm.pickedView)
                
            }.padding(.trailing, 8)
            
            VStack {
                if vm.pickedView == .custom {
                    VStack {
                        HStack {
                            CustomTextField(text: $vm.companyName, placeholder: "Name")
                            
                            CustomTextField(text: $vm.mlVolume, placeholder: "Milliliters", numberPad: true)
                                .frame(width: 100)
                        }
                        HStack {
                            CustomTextField(text: $vm.taste, placeholder: "Taste or subname")
                            
                            CustomTextField(text: $vm.mgCoffeinPer100, placeholder: "Mg/100ml", numberPad: true)
                                .frame(width: 100)
                        }
                        
                    }.frame(maxWidth: .infinity)
                        .transition(.opacity)
                }
                
                    Text("Add")
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(Color.main)
                        .cornerRadius(5)
                        .onTapGesture {
                            hideKeyboard()
                            vm.saveDrink()
                        }
                
                
                if vm.pickedView == .already {
                    HStack {
                        VStack {
                            Menu {
                                ForEach(EnergyCompany.data.keys.sorted(), id: \.self) { companyName in
                                    Button {
                                        vm.pickedCompany = companyName
                                    } label: {
                                        Text(companyName)
                                            .tag(companyName)
                                    }
                                }
                            } label: {
                                Text(vm.pickedCompany)
                                    .customMenu()
                            }
                            
                            HStack {
                                Menu {
                                    ForEach(EnergyCompany.data[vm.pickedCompany]!.choises, id: \.taste) { item in
                                        Button {
                                            vm.pickedDrink = item
                                        } label: {
                                            Text(item.taste)
                                        }
                                    }
                                } label: {
                                    Text(vm.pickedDrink?.taste ?? "None")
                                        .lineLimit(1)
                                        .customMenu(horPadding: false)
                                }
                                
                                Menu {
                                    ForEach(vm.pickedDrink!.mlVolume, id: \.description) { item in
                                        Button {
                                            vm.pickedVolume = item
                                        } label: {
                                            Text("\(item) ml")
                                        }
                                        
                                    }
                                } label: {
                                    Text("\(vm.pickedVolume!) ml")
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .frame(maxWidth: .infinity)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(5)
                                }
                            }
                        }
                        
                        Image(vm.pickedDrink!.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .shadow( color: .white, radius: 1)
                            .frame(width: 50)
                    }.frame(maxWidth: .infinity)
                        .transition(.opacity)
                }
                
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
                .foregroundColor(.white)
                .alert(isPresented: $vm.showAlert) {
                    Alert(title: Text("Error!"),
                          message: Text(vm.textAlert),
                          dismissButton: .default(Text("ОК"))
                    )
                }
        }.padding([.trailing, .vertical])
            .padding(.leading, 8)
    }
}


#Preview {
    ContentView()
        .environmentObject(MainViewModel())
        .preferredColorScheme(.dark)
}

struct CustomTextField: View {
    @EnvironmentObject var vm: MainViewModel
    @FocusState private var isTextFieldFocused: Bool
    @Binding var text: String
    
    var placeholder: String
    var numberPad: Bool = false
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(numberPad ? .numberPad: .default)
            .focused($isTextFieldFocused)
            .padding(5)
            .animation(.easeInOut, value: isTextFieldFocused)
            .animation(.easeInOut, value: text.isEmpty)
            .padding(.horizontal, 3)
            .background(Color(.systemGray5))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(lineWidth: 1)
                    .foregroundColor(isTextFieldFocused || !text.isEmpty ? Color.main : Color(.systemGray2))
            }
    }
}

