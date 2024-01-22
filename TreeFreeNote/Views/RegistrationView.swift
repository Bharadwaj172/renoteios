//
//  RegistrationView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 06/06/23.
//

import SwiftUI


struct RegistrationView: View {

@State var username: String = ""
@State var password: String = ""
    @State var passwordVerify: String = ""
@State private var showPassword = false
@State private var showPasswordVerify = false
@State private var current: Int? = nil


var body: some View {

    NavigationView{

        GeometryReader { (deviceSize: GeometryProxy) in

            ZStack {
                //Define a screen color
                LinearGradient (gradient: Gradient(colors:[Color.red.opacity(0.9),Color.green.opacity(0.8)]),startPoint: .leading,endPoint: .trailing)
                    //Extend the screen to all edges
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text ("Create Account")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding ()

                    Group {
                        HStack {
                            Image ("user")
                                .resizable ()
                                .scaledToFit()
                                .padding (10)

                            TextField("Username", text: $username)
                                .padding(12)
                                .padding (.leading, -10)
                                .padding(.leading, -3)
                            Spacer ()
                        } .padding (.leading, 10)

                        Spacer ()

                        HStack {
                            Image ("mail")
                                .resizable ()
                                .scaledToFit()
                                .padding (10)

                            TextField("Email", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                                .padding(12)
                                .padding (.leading, -10)
                                .padding(.leading, -3)
                        } .padding (.leading, 10)

                        Spacer()

                        HStack {
                            Image ("phone")
                                .resizable ()
                                .scaledToFit()
                                .padding (10)

                            TextField("Phone", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                                .padding(12)
                                .padding (.leading, -10)
                                .padding(.leading, -3)
                        } .padding (.leading, 10)

                        Spacer()


                        HStack {
                            Image("unlock")
                                .resizable()
                                .scaledToFit()
                                .padding (11)
                            if self.showPassword == true{
                                TextField("Password", text: self.$password)
                                    .padding(12)
                                    .padding (.leading, -10)
                                    .padding(.leading, -3)
                                // .frame(width: 175)// if you want to custom where the lock,passwordm and eye relation
                            } else {
                                SecureField("Password", text: self.$password)
                                    .padding(12)
                                    .padding (.leading, -10)
                                    .padding(.leading, -3)

                            }
                            Button (action: {self.showPassword.toggle()}) {
                                if self.showPassword == true {
                                    Image("eye-unlock")
                                        .resizable()
                                        .scaledToFit()
                                        .padding (11)
                                        .foregroundColor (.secondary)
                                } else {
                                    Image("eye")
                                        .resizable()
                                        .scaledToFit()
                                        .padding (11)
                                        .foregroundColor (.secondary)
                                }

                            }// closes button
                        } .padding(.leading, 10)//close Hstack for lock
                            .padding (.trailing, 10)

                        Spacer()

                        HStack {
                            Image("unlock")
                                .resizable()
                                .scaledToFit()
                                .padding (11)
                            if self.showPasswordVerify == true{
                                TextField("Verify Password", text: self.$passwordVerify)
                                    .padding(12)
                                    .padding (.leading, -10)
                                    .padding(.leading, -3)
                                // .frame(width: 175)// if you want to custom where the lock,passwordm and eye relation
                            } else {
                                SecureField("Verify Password", text: self.$passwordVerify)
                                    .padding(12)
                                    .padding (.leading, -10)
                                    .padding(.leading, -3)

                            }
                            Button (action: {self.showPasswordVerify.toggle()}) {
                                if self.showPasswordVerify == true {
                                    Image("eye-unlock")
                                        .resizable()
                                        .scaledToFit()
                                        .padding (11)
                                        .foregroundColor (.secondary)
                                } else {
                                    Image("eye")
                                        .resizable()
                                        .scaledToFit()
                                        .padding (11)
                                        .foregroundColor (.secondary)
                                }

                            }// closes button
                        } .padding(.leading, 10)//close Hstack for lock
                            .padding (.trailing, 10)


                    }.background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .shadow(radius: 10)
                        .frame(maxHeight:40, alignment: .leading)
                        .padding(.leading, 25)
                        .padding (.trailing, 25)




                    VStack (spacing: 2) {
                        Button (action: {print("create Account pressed!!")}) {
                            Text("Create")
                                .fontWeight(.bold)
                                .padding(10)
                                .foregroundColor(.orange)

                                .padding (.leading, 75)
                                .padding(.trailing, 75)


                        } .padding (.leading, 10)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 2)))
                            .shadow(radius: 10)
                            .frame(maxHeight:40, alignment: .leading)
                        Spacer()
                        Text ("OR")
                            .fontWeight(.black)
                            .foregroundColor(.white)

                        Spacer()

                        Text ("Sign up using social accounts")
                            .foregroundColor(.white)
                            .fontWeight(.light)
                        Spacer ()

                        HStack {
                            Button (action: {print("Facebook Account pressed!!")}) {
                                Image("facebook")
                                .resizable()
                                .scaledToFit()
                                .padding (-3)


                        }
                            Spacer()

                            Button (action: {print("Twitter Account pressed!!")}) {
                                Image("twitter")
                                    .resizable()
                                    .scaledToFit()
                                .padding (-3)

                            }
                            Spacer()

                            Button (action: {print("Twitter Account pressed!!")}) {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                .padding (-3)


                            }
                        }.padding(.trailing, 45)
                            .padding (.leading, 45)
                            .offset(y: 10)
                        .buttonStyle(PlainButtonStyle())//allows buttons to render correclty whilein a navi view

                    }.padding(.top, 40)
                        .offset (y: -10)




                }
                    .offset (y:-50)

            }

        }
    }
}
}

struct RegistrationView_Previews: PreviewProvider {
static var previews: some View {
    RegistrationView()
  }
}



/*
 
 import SQLite

 let imageMetadataTable = Table("ImageMetadata")
 let id = Expression<Int>("id")
 let filename = Expression<String>("filename")
 let filepath = Expression<String>("filepath")
 let creationDate = Expression<String>("creationDate")
 let associatedData = Expression<String>("associatedData")

 // Additional columns as per your requirements

 
 
 let userTable = Table("User")
 let userId = Expression<Int>("id")

 let userImageTable = Table("UserImage")
 let userIdFK = Expression<Int>("userId")
 let imageIdFK = Expression<Int>("imageId")

 // Define columns and foreign key relationships for other tables as needed

 
 
 
 */
