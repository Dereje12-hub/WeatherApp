//
//  SwiftUIErrorView.swift
//  WeatherApp
//
//  Created by Consultant on 5/22/23.
//

import SwiftUI

struct SwiftUIErrorView: View {
    
    var navigateController: UINavigationController?
    
    var body: some View {
      
            VStack{
                Text("Sorry Input is not found in the db!")
               
            }.padding()
        }
    
}

struct SwiftUIErrorView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIErrorView()
    }
}
