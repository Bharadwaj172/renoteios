//
//  FolderCreationView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 17/06/23.
//

import SwiftUI
import GoogleSignIn
import GoogleAPIClientForREST

struct FolderCreationView: View {
    
    @State var isFolderLockEnabled: Bool = false
    @State private var enableFaceId = false
    @Binding var isShowingBottomSheet: Bool
    
    @State private var folderName: String = ""
    @Binding var saveAccount: String //= "Device"
    @State private var email: String = ""
    
    @State private var selectedStorageType: String = ""

    @State private var gDriveUsers: [String] = [String]()
    
    @EnvironmentObject var googleAuth : GoogleAuthModel

    var createFolder: ((String) -> ())?

    @ObservedObject var folderCreationObserver = FolderCreationObserver.shared
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isShowingBottomSheet = false //.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal, 10)
                }
            }
            .padding(.bottom, -10)
            
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "tag.fill")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                Text("New Folder")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 15) {
            
                FormInputView(formInputText: $folderName, fieldName: "Name", fieldPlaceholder: "Enter Name")
                FormInputView(formInputText: $saveAccount, fieldName: "Save/Share", fieldPlaceholder: "Select Account", isDropDown: true, dropDownList: ["Device", "GoogleDrive"])
                FormInputView(formInputText: $email, fieldName: "Email/Phone", fieldPlaceholder: "test@gmail.com")
                
                /*
                 LockView(isFolderLockEnabled: $isFolderLockEnabled)

                if isFolderLockEnabled {
                    VStack {
                        HStack(alignment: .top) {
                            Text("Create Pin")
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            Spacer()
                            PasscodeField("") { digits, action in
//                                if "1234" == digits.concat {
//                                    action(true)
//                                } else {
//                                    action(false)
//                                }
                            }
                            .fixedSize(horizontal: true, vertical: true)
                        }
                        .frame(height: 75)
                        
                        /*
                        HStack {
                            Text("Enable face Id")
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            Spacer()
                            
                            Toggle("", isOn: $enableFaceId)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                        }
                        .padding(.top, 8)
                         */
                        
                    }
                    .padding(.horizontal, 27)
                }
                */
                Button (action: {
                    self.createFolderWithInfo()
                    isShowingBottomSheet = false//.toggle()
                    self.createFolder?(folderName)
                    FoldersObserver.shared.isFolderCreated = true

                }) {
                    Text("Create")
                        .fontWeight(.bold)
                        .padding(10)
                        .foregroundColor(.white)
                        .padding (.horizontal, 120)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 3/255.0, green: 151/255.0, blue: 41/255.0, alpha: 1)), Color(UIColor(red: 78/255.0, green: 234/255.0, blue: 118/255.0, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20, corners: .allCorners)
                .padding(.top, 30)
            }
        }
        .padding(.bottom, 42)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: folderCreationObserver.isStorageTypeModified) { newValue in
            selectedStorageType = newValue
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                googleAuth.signIn()
            }
            folderCreationObserver.isStorageTypeModified = ""
        }
        .onChange(of: googleAuth.email) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                email = googleAuth.email
            }
        }
    }
    
    private func createFolderWithInfo() {
        let query = querys()
        let is_exits = query.value_exits(folder_name: self.folderName)
//        var folder_id = ""
        if is_exits {
            //TODO: Show alert folder name exists or continue with existing folder
//            folder_id = query.get_folder_id(folder_name: self.folderName)
                
        } else {
            query.insertFolder(folder_name: self.folderName, parent_folder: "", cloud_storage_id: self.email, storage_type: self.selectedStorageType)
            
            //TODO: Show Folder creation success alert
//            folder_id = query.get_max_id_table(table_name: DBTableName.folders.rawValue)
        }
        
    }
    
//    private func getGoogleDriveUsersFromDefaults() {
//
//        if let userArray = AppPersistenceUtility.getObjectFromUserDefaults(key: "GoogleDriveUsers") as? Dictionary<String, Any> {
//            if let gmailId = userArray.keys.first {
//                email = gmailId
//            }
//        }
//    }
}


//struct FolderCreationView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderCreationView( isShowingBottomSheet: .constant(true))
//    }
//}

class FolderCreationObserver: ObservableObject {
    static var shared = FolderCreationObserver()
    @Published var isStorageTypeModified: String = ""
}
