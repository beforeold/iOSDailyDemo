import SwiftUI

struct ContentView: View {
    private let products = [
        Product(
            name: "MobiOffice",
            tagline: "A mobile-first office suite for documents, spreadsheets, and presentations.",
            systemImage: "doc.text.magnifyingglass"
        ),
        Product(
            name: "MobiPDF",
            tagline: "PDF viewing, editing, signing, and sharing tools built for productivity.",
            systemImage: "signature"
        ),
        Product(
            name: "MobiDrive",
            tagline: "Cloud storage and file sync designed around cross-device access.",
            systemImage: "externaldrive.badge.icloud"
        )
    ]

    private let solutions = [
        "Industry workflows for mobile carriers, device makers, and enterprise mobility.",
        "AI-assisted productivity experiences focused on mobile users and distributed teams.",
        "Cloud services that connect editing, storage, and secure document handling."
    ]

    private let news = [
        "MobiSystems highlights AI integration across its productivity tools.",
        "The company continues expanding its global app footprint across mobile and desktop.",
        "Career listings emphasize engineering, product, and growth roles in Sofia and beyond."
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.98, blue: 1.0),
                    Color(red: 0.86, green: 0.93, blue: 0.99),
                    Color(red: 0.98, green: 0.98, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroSection
                    statsSection
                    sectionTitle("Products")
                    productSection
                    sectionTitle("Solutions")
                    solutionsSection
                    sectionTitle("About")
                    aboutSection
                    sectionTitle("Newsroom")
                    newsSection
                    sectionTitle("Contact")
                    contactSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 28)
            }
            .scrollIndicators(.hidden)
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("MobiSystems")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 0.07, green: 0.15, blue: 0.31))

            Text("Native iOS snapshot of mobiuspace.com")
                .font(.headline)
                .fontDesign(.serif)
                .foregroundStyle(.secondary)

            Text("Productivity software for mobile and desktop users, spanning office apps, PDF tools, cloud storage, and enterprise mobility solutions.")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color(red: 0.08, green: 0.14, blue: 0.24))

            Text("This screen translates the current website into an iPhone-first experience, keeping the main company messaging, product lineup, and contact points in a native layout.")
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Link("Visit Website", destination: URL(string: "https://www.mobiuspace.com/")!)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.09, green: 0.39, blue: 0.72))

                Link("Careers", destination: URL(string: "https://www.mobiuspace.com/careers/")!)
                    .buttonStyle(.bordered)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(Color(red: 0.98, green: 0.71, blue: 0.23).opacity(0.28))
                        .frame(width: 150, height: 150)
                        .offset(x: 30, y: -40)
                }
        )
    }

    private var statsSection: some View {
        HStack(spacing: 14) {
            StatCard(value: "20+", label: "Years building mobile productivity")
            StatCard(value: "550M+", label: "Users reached globally")
            StatCard(value: "190+", label: "Markets served worldwide")
        }
    }

    private var productSection: some View {
        VStack(spacing: 14) {
            ForEach(products) { product in
                VStack(alignment: .leading, spacing: 10) {
                    Label(product.name, systemImage: product.systemImage)
                        .font(.headline)
                        .foregroundStyle(Color(red: 0.08, green: 0.14, blue: 0.24))

                    Text(product.tagline)
                        .foregroundStyle(.secondary)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.88))
                )
            }
        }
    }

    private var solutionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(solutions, id: \.self) { solution in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "sparkles.rectangle.stack")
                        .foregroundStyle(Color(red: 0.91, green: 0.48, blue: 0.13))
                        .padding(.top, 2)

                    Text(solution)
                        .foregroundStyle(Color(red: 0.18, green: 0.24, blue: 0.33))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.99, green: 0.96, blue: 0.89))
        )
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mobiuspace presents MobiSystems as a global software company focused on helping people work across documents, PDFs, storage, and mobile workflows. The site also foregrounds its international team, long product history, and emphasis on accessible productivity tools.")
            Text("The web experience mixes consumer products with enterprise offerings, so the native version keeps both: end-user apps at the top, company context in the middle, and business-facing capabilities below.")
        }
        .foregroundStyle(.secondary)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.84))
        )
    }

    private var newsSection: some View {
        VStack(spacing: 12) {
            ForEach(news.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: 14) {
                    Text("\(index + 1)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(Color(red: 0.16, green: 0.46, blue: 0.71)))

                    Text(news[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color(red: 0.18, green: 0.24, blue: 0.33))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.84))
        )
    }

    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            contactRow(title: "Website", value: "mobiuspace.com", url: "https://www.mobiuspace.com/")
            contactRow(title: "Address", value: "Sofia, Bulgaria", url: nil)
            contactRow(title: "Focus", value: "Mobile productivity, PDF, cloud storage, and enterprise mobility", url: nil)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.08, green: 0.14, blue: 0.24))
        )
    }

    @ViewBuilder
    private func contactRow(title: String, value: String, url: String?) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.white.opacity(0.7))

            if let url, let destination = URL(string: url) {
                Link(value, destination: destination)
                    .foregroundStyle(.white)
            } else {
                Text(value)
                    .foregroundStyle(.white)
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.title2.bold())
            .foregroundStyle(Color(red: 0.08, green: 0.14, blue: 0.24))
    }
}

private struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.title.bold())
                .foregroundStyle(Color(red: 0.08, green: 0.14, blue: 0.24))

            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.84))
        )
    }
}

private struct Product: Identifiable {
    let id = UUID()
    let name: String
    let tagline: String
    let systemImage: String
}

#Preview {
    ContentView()
}
