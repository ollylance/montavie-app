//
//  NewPostAddView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/20/22.
//

import SwiftUI
import MapKit

struct NewPostAddView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var post: Post
    @State var editText = false
    @State var showDatePicker = false
    @State var showLocation = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    PhotoSelectView(post: $post)
                    VStack(alignment: .leading) {
                        HStack (alignment: .top) {
                            Button(action: {showDatePicker.toggle()}) {
                                VStack(alignment: .leading) {
                                    Text(getFormattedDate(format: "MM/dd/yyyy", date: post.date))
                                        .font(.system(size: 30, weight: .bold, design: .rounded))
                                        .foregroundColor(Color("BrandDarkGrey"))
                                        .padding(.horizontal)
                                    Text(getFormattedDate(format: "h:mm a", date: post.date))
                                        .font(.system(size: 25, weight: .light, design: .rounded))
                                        .foregroundColor(Color("BrandDarkGrey"))
                                        .padding(.horizontal)
                                }
                            }
                            Spacer()
                            if ((post.location) != nil) {
                                Button(action: {showLocation.toggle()}) {
                                    Image("LocationIcon")
                                        .blending(color: Color("BrandDarkGrey"))
                                        .frame(width: 30, height: 30)
                                }
                                .padding(.trailing)
                            }
                        }
                        
                        if post.text != "" {
                            Text(post.text)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .padding()
                                .onTapGesture {
                                    editText.toggle()
                                }
                        } else {
                            Text("Write something...")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .padding()
                                .foregroundColor(Color("BrandLightGrey"))
                                .onTapGesture {
                                    editText.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(.keyboard)
                }
            }
            .fullScreenCover(isPresented: $editText) {
                VStack {
                    HStack {
                        Text("Edit Text")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 35, weight: .medium, design: .rounded))
                            .padding()
                        Spacer()
                        Button(action: {editText.toggle()}) {
                            Image("Check")
                                .blending(color: Color("BrandDarkGrey"))
                                .frame(width: 35, height: 35)
                                .padding()
                        }
                    }
                    TextEditView(text: $post.text)
                        .frame(maxHeight: .infinity)
                        .padding([.horizontal, .bottom])
                }
            }
            .sheet(isPresented: $showDatePicker) {
                if #available(iOS 16, *) {
                    DatePicker("", selection: $post.date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(alignment: .leading)
                        .presentationDetents([.height(400)])
                } else {
                    DatePicker("", selection: $post.date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(alignment: .leading)
                }
            }
            .fullScreenCover(isPresented: $showLocation) {
                LocationView(post: $post)
            }
        }
    }
}

struct NewPostAddView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostAddView(post: .constant(Post(text: "")))
    }
}
