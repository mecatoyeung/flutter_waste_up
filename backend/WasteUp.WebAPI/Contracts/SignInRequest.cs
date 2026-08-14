namespace WasteUp.WebAPI.Contracts;

public class SignInRequest
{
    public string? Username { get; init; }

    public string? Password { get; init; }
}