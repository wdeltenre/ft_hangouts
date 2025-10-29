//
//  SettingsFormView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 20/10/2025.
//

/// This view creates a form for both the color and language settings

import SwiftUI

struct SettingsFormView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Form {
                LanguageSection(viewModel: viewModel)
                
                ColorSection(viewModel: viewModel)
            }
        }
    }
}

private struct LanguageSection: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section(header: Text("SELECT_LANGUAGE".localized(using: viewModel.localizationManager))) {
            Button {
                withAnimation {
                    viewModel.isLanguageExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("CURRENT_LANGUAGE".localized(using: viewModel.localizationManager))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(
                        "\(viewModel.localizationManager.selectedLanguage.flag) \(viewModel.localizationManager.selectedLanguage.displayName)"
                    )
                    .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(viewModel.isLanguageExpanded ? 90 : 0))
                        .animation(.easeInOut, value: viewModel.isLanguageExpanded)
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(.plain)
            
            if viewModel.isLanguageExpanded {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        viewModel.localizationManager.setLanguage(lang)
                        withAnimation {
                            viewModel.isLanguageExpanded = false
                        }
                    } label: {
                        HStack {
                            Text("\(lang.flag) \(lang.displayName)")
                            Spacer()
                            if viewModel.localizationManager.selectedLanguage == lang {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

private struct ColorSection: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Section(header: Text("SELECT_COLOR".localized(using: viewModel.localizationManager))) {
            Button {
                withAnimation {
                    viewModel.isColorExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("CURRENT_COLOR".localized(using: viewModel.localizationManager))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: viewModel.colorThemeManager.selectedColor.iconName)
                        .foregroundColor(viewModel.colorThemeManager.selectedColor.color)
                    Text(viewModel.colorThemeManager.selectedColor.displayName)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(viewModel.isColorExpanded ? 90 : 0))
                        .animation(.easeInOut, value: viewModel.isColorExpanded)
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(.plain)
            
            if viewModel.isColorExpanded {
                ForEach(AppThemeColor.allCases) { color in
                    Button {
                        viewModel.colorThemeManager.setColor(color)
                        withAnimation {
                            viewModel.isColorExpanded = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: color.iconName)
                                .foregroundColor(color.color)
                            Text(color.displayName)
                            Spacer()
                            if viewModel.colorThemeManager.selectedColor == color {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}
