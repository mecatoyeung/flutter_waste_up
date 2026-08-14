namespace WasteUp.WebAPI.Contracts;

public class GoogleSignInRequest
{
    public string? IdToken { get; init; }

    public bool RememberMe { get; init; } = true;
}