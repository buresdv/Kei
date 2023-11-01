//
//  Key Detail View.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct KeyDetailView: View {
    
    let key: SSHKey
    
    @State private var isPrivateKeyDisplayed: Bool = false
    
    @State private var hasCopiedPublicKey: Bool = false
    @State private var hasCopiedPrivateKey: Bool = false
    
    var body: some View {
        Form {
            Section
            {
                Section
                {
                    Text(key.publicKey)
                        .textSelection(.enabled)
                } header: {
                    HStack(alignment: .center, spacing: 5, content: {
                        Text("Public Key")
                        
                        Spacer()
                        
                        if !hasCopiedPublicKey
                        {
                            Button(action: {
                                copyToClipboard(whatToCopy: key.publicKey)
                                
                                hasCopiedPublicKey = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3)
                                {
                                    hasCopiedPublicKey = false
                                }
                            }, label: {
                                Text("Copy Public Key")
                            })
                        }
                        else
                        {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20)
                                .foregroundColor(.green)
                        }
                    })
                    .font(.system(size: 12))
                }

                Section
                {
                    DisclosureGroup(isExpanded: $isPrivateKeyDisplayed)
                    {
                        Text(key.privateKey)
                            .textSelection(.enabled)
                    } label: {
                        Text(isPrivateKeyDisplayed ? "Hide Private Key" : "Show Private Key")
                    }
                } header: {
                    HStack(alignment: .center, spacing: 5, content: {
                        Text("Private Key")
                        
                        Spacer()
                        
                        if !hasCopiedPrivateKey
                        {
                            Button(action: {
                                copyToClipboard(whatToCopy: key.privateKey)
                                
                                hasCopiedPrivateKey = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3)
                                {
                                    hasCopiedPrivateKey = false
                                }
                            }, label: {
                                Text("Copy Private Key")
                            })
                        }
                        else
                        {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20)
                                .foregroundColor(.green)
                        }

                    })
                    .font(.system(size: 12))
                }
                
            } header: {
                HStack(alignment: .firstTextBaseline, spacing: 10, content: {
                    Text(key.name)
                        .font(.title)
                    
                    Text(key.createdAt.formatted(.dateTime))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                })
            }
        }
        .formStyle(.grouped)
    }
}
