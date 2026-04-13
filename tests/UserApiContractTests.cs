using PactNet;
using Xunit;
using Xunit.Abstractions;
using UserApiConsumer;

namespace UserApiConsumer.Tests;

public class UserApiContractTests
{
    private readonly ITestOutputHelper _outputHelper;

    public UserApiContractTests(ITestOutputHelper outputHelper)
    {
        _outputHelper = outputHelper;
    }

    [Fact]
    public async Task GetUser_WhenUserExists_ReturnsUser()
    {
        // Configure Pact
        var pactConfig = new PactConfig
        {
            PactDir = Path.Combine("..", "..", "..", "..", "pacts"),
            LogLevel = PactLogLevel.Debug
        };

        var pact = Pact.V4("UserApiConsumer", "UserApiProvider", pactConfig)
            .WithHttpInteractions();

        // Arrange - Define the expected interaction
        pact.UponReceiving("A request to get user with id 1")
                .Given("User with id 1 exists")
                .WithRequest(HttpMethod.Get, "/users/1")
            .WillRespond()
                .WithStatus(200)
                .WithHeader("Content-Type", "application/json")
                .WithJsonBody(new
                {
                    id = 1,
                    name = "John Doe",
                    email = "john.doe@example.com"
                });

        // Act & Assert - Verify the interaction
        await pact.VerifyAsync(async ctx =>
        {
            var client = new UserApiClient(ctx.MockServerUri.ToString());
            var user = await client.GetUserAsync(1);

            Assert.NotNull(user);
            Assert.Equal(1, user.Id);
            Assert.Equal("John Doe", user.Name);
            Assert.Equal("john.doe@example.com", user.Email);
            
            _outputHelper.WriteLine($"✓ Successfully retrieved user: {user.Name}");
        });
        
        _outputHelper.WriteLine("✓ Pact file generated successfully");
    }
}
