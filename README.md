# User API Consumer

This is the **Consumer** project for demonstrating Contract Testing with Pact.

## Project Structure

- `src/` - Consumer client code that calls the User API
- `tests/` - Pact contract tests
- `pacts/` - Generated pact files (created after running tests)

## What This Does

The consumer expects to call a User API Provider with:
- **Endpoint**: `GET /users/{id}`
- **Response**: JSON with user details (id, name, email)

## Running Locally

### 1. Run Contract Tests

```powershell
dotnet test
```

This will:
- Run the contract test
- Generate a pact file in `pacts/` directory
- The pact file describes the expected interaction with the provider

### 2. View Generated Pact

Check `pacts/UserApiConsumer-UserApiProvider.json` to see the contract.

### 3. Publish to Pact Broker

Use the publish script:

```powershell
.\publish-pact.ps1
```

Or specify a custom version:

```powershell
.\publish-pact.ps1 -Version "1.0.0"
```

Or manually:

```powershell
# Set version (use git commit hash or version number)
$version = git rev-parse --short HEAD

# Publish using curl
$pactFile = "pacts/UserApiConsumer-UserApiProvider.json"
$url = "http://puvsfpactserver.tiger01-dev.ba.lab.local:9292/pacts/provider/UserApiProvider/consumer/UserApiConsumer/version/$version"

curl.exe -X PUT -H "Content-Type: application/json" -d "@$pactFile" $url
```

## GitHub Actions Pipeline

The pipeline (`.github/workflows/consumer-pipeline.yml`) automatically:
1. ✅ Runs contract tests
2. 📦 Generates pact file
3. � Uploads pact as artifact

**Note**: Publishing to Pact Broker is done manually from your local machine since the broker is not accessible from GitHub's cloud runners. Use `.\publish-pact.ps1` after the pipeline succeeds.

### Setting Up GitHub Repository

1. Create a new repository on GitHub
2. Initialize git and push:

```powershell
cd C:\Users\wd979475\source\repos\UserApiConsumer
git init
git add .
git commit -m "Initial consumer setup with Pact contract test"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/UserApiConsumer.git
git push -u origin main
```

## Pact Broker

- **URL**: http://puvsfpactserver.tiger01-dev.ba.lab.local:9292/
- View published contracts and verification status

## Next Steps

After this consumer is set up:
1. Create the **Provider** project
2. Configure provider to verify this pact
3. Set up webhook to trigger provider verification when this pact changes
