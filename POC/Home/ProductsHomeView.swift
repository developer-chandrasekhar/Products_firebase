//
//  ProductsHomeView.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import SwiftUI

struct ProductsHomeView: View {
    
    @ObservedObject var viewModel: ProductsHomeViewModel
    @State private var showSettingsScreen = false
    
    let spacing: CGFloat = 10
    
    var productsColumns = [
        GridItem(alignment: .leading),
        GridItem(alignment: .leading)
    ]
    
    init(viewModel: ProductsHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HeaderView().padding(.horizontal)
                Text("Order right away!!")
                    .font(FontManager.caption())
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                separator().padding(.vertical)
                sectionTitleView(title: "Categories:")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.productsCategories.indices, id: \.self) { index in
                            tagView(tag: viewModel.productsCategories[index])
                                .padding(.trailing, index == viewModel.productsCategories.count - 1 ? 16: 4)
                                .padding(.vertical, 2)
                                .onTapGesture {
                                    viewModel.filterByCategory(category: viewModel.productsCategories[index])
                                }
                        }
                    }
                }
                .padding(.leading)
                .padding(.top)
                separator().padding(.vertical)
                sectionTitleView(title: "Featured Items:")
                    .padding(.bottom, 12)
                ScrollView(showsIndicators: false) {
                    if viewModel.products.count > 0 {
                        LazyVGrid(columns: productsColumns, spacing: 4) {
                            ForEach(viewModel.products.indices, id: \.self) { index in
                                let product = viewModel.products[index]
                                productView(product: product)
                            }
                        }
                    }
                    else {
                        EmptyView()
                    }
                }
                Spacer()
            }
            .onAppear {
                viewModel.getAllProducts()
            }
            .navigationDestination(isPresented: $showSettingsScreen) {
                ProfileSettingsView()
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension ProductsHomeView {
    func HeaderView() -> some View {
        HStack(spacing: 0) {
            Text("Hungry")
                .font(FontManager.largeTitle(weight: .bold))
            Image(ImageNames.hungry_smiley)
            Text("?")
                .font(FontManager.largeTitle(weight: .bold))
            Spacer()
            Button {
            } label: {
                Image(ImageNames.favorite_available)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44)
            }
            .disabled(viewModel.favouriteProducts.count == 0)
            .opacity(viewModel.favouriteProducts.count == 0 ? 0.5 : 1)
            .padding(.trailing)
            Button {
                showSettingsScreen.toggle()
            } label: {
                Image(ImageNames.settings_icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44)
            }
        }
    }
    
    func sectionTitleView(title: String) -> some View {
        Text(title)
            .font(FontManager.headline(weight: .semibold))
            .padding(.horizontal)
    }
    
    func separator() -> some View {
        Rectangle().fill(.gray.opacity(0.1))
            .frame(maxWidth: .infinity)
            .frame(height: 12)
    }
    
    func tagView(tag: String) -> some View {
        HStack {
            Image(ImageNames.hungry_smiley)
                .resizable()
                .scaledToFit()
                .frame(height: 18)
                .padding(.leading, 0)
            Text(tag)
                .font(FontManager.caption())
                .foregroundColor(tag.uppercased() == viewModel.selectedCategory.uppercased() ? .white : .black)
        }
        .padding(.leading, 6)
        .padding(.trailing, 16)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(tag.uppercased() == viewModel.selectedCategory.uppercased() ? .black : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.black)
                )
        )
    }
    
    func productView(product: ProductModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } placeholder: {
                Image(ImageNames.logo_large)
                    .resizable()
                    .clipped()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.45)
            }
            .overlay {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.black.opacity(0.2))
                    if let rating = product.rating {
                        HStack {
                            //Spacer()
                            Image(ImageNames.star_icon)
                                .padding(.leading, 8)
                            Text(String(rating))
                                .font(FontManager.caption2())
                                .foregroundStyle(ColorManager.ratingYellow)
                                .padding(.vertical, 4)
                                .padding(.trailing, 8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.black.opacity(0.6))
                        )
                        .padding()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: (UIScreen.main.bounds.width * 0.5))
            
            Text(product.title)
                .font(FontManager.caption())
                .padding(.horizontal)
            HStack {
                CurrencyText(product.price)
                    .font(FontManager.caption())
                Spacer()
                Button {
                    viewModel.favouriteTapped(product.id)
                } label: {
                    Image(viewModel.isFavouriteProduct(product.id) ? ImageNames.favorite_fill  : ImageNames.favorite_stroke)
                }
                .padding(.trailing, 4)
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProductsHomeView(viewModel: ProductsHomeViewModel(productsService: ProductsMockService()))
}

extension String {
    func widthOfString(usingFont font: Font) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes).width
    }
}

struct CurrencyText: View {
    
    let text: Double
    
    init(_ text: Double) {
        self.text = text
    }
    
    var body: some View {
        Text(String(format: "$%.2f", text))
    }
}

