struct titleCategory: View {
    var title: String
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
                .padding(.horizontal,20)
                .padding(.top,15)
        }
    }
}
