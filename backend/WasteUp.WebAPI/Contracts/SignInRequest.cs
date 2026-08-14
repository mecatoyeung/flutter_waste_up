namespace WasteUp.WebAPI.Contracts;

public class SignInRequest
{
    public string? Username { get; init; }

    public string? Password { get; init; }

    public bool RememberMe { get; init; }
}