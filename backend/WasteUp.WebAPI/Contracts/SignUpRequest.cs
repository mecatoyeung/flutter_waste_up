namespace WasteUp.WebAPI.Contracts;

public class SignUpRequest
{
    public string? Username { get; init; }

    public string? Password { get; init; }

    public string? ConfirmPassword { get; init; }
}