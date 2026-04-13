using System.Text.Json;

namespace UserApiConsumer;

public class User
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
}

public class UserApiClient
{
    private readonly HttpClient _httpClient;

    public UserApiClient(string baseUrl)
    {
        _httpClient = new HttpClient { BaseAddress = new Uri(baseUrl) };
    }

    public UserApiClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<User?> GetUserAsync(int userId)
    {
        var response = await _httpClient.GetAsync($"/users/{userId}");
        response.EnsureSuccessStatusCode();
        
        var content = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<User>(content, new JsonSerializerOptions 
        { 
            PropertyNameCaseInsensitive = true 
        });
    }
}
