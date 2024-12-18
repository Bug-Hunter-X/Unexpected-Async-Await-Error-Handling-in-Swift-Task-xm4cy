func fetchData() async throws -> Data {
    let url = URL(string: "https://api.example.com/data")!
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    return data
}

Task { 
    do {
        let data = try await fetchData()
        // Process the data
    } catch {
        print("Error fetching data: \(error)")
    }
} 

//Improved solution with more robust error handling
Task { 
    do {
        let data = try await withThrowingTaskGroup(of: Data.self) { group in
            group.addTask { try await fetchData() }
            return try await group.next()!
        }
        //Process data
    } catch {
        print("Error: \(error)")
    }
} 