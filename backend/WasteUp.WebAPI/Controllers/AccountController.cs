using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using WasteUp.WebAPI.Contracts;
using WasteUp.WebAPI.Models;

namespace WasteUp.WebAPI.Controllers;

[ApiController]
[Route("account")]
public class AccountController(
    UserManager<UserAccount> userManager,
    IConfiguration configuration) : ControllerBase
{
    private const string AuthenticationCookieName = "wasteup_auth";

    [HttpPost("signup")]
    public async Task<IActionResult> SignUp(SignUpRequest request, CancellationToken cancellationToken)
    {
        var username = request.Username?.Trim();

        if (string.IsNullOrWhiteSpace(username))
        {
            return BadRequest(new { error = "Username is required." });
        }

        if (request.Password != request.ConfirmPassword)
        {
            return BadRequest(new { error = "Password and confirm password must match." });
        }

        if (string.IsNullOrEmpty(request.Password))
        {
            return BadRequest(new { error = "Password is required." });
        }

        var result = await userManager.CreateAsync(new UserAccount
        {
            UserName = username
        }, request.Password);

        if (!result.Succeeded)
        {
            if (result.Errors.Any(error => error.Code == nameof(IdentityErrorDescriber.DuplicateUserName)))
            {
                return Conflict(new { error = "Username is already in use." });
            }

            return BadRequest(new
            {
                errors = result.Errors.Select(error => new { error.Code, error.Description })
            });
        }

        return StatusCode(StatusCodes.Status201Created, new { message = "Account created." });
    }

    [HttpPost("signin")]
    public async Task<IActionResult> SignIn(SignInRequest request)
    {
        var username = request.Username?.Trim();

        if (string.IsNullOrWhiteSpace(username) || string.IsNullOrEmpty(request.Password))
        {
            return BadRequest(new { error = "Username and password are required." });
        }

        var user = await userManager.FindByNameAsync(username);

        if (user is null || !await userManager.CheckPasswordAsync(user, request.Password))
        {
            return Unauthorized(new { error = "Invalid username or password." });
        }

        var expiresAt = DateTime.UtcNow.AddHours(8);
        var accessToken = CreateAccessToken(user, expiresAt);
        Response.Cookies.Append(AuthenticationCookieName, accessToken, new CookieOptions
        {
            HttpOnly = true,
            Secure = true,
            SameSite = SameSiteMode.Strict,
            Expires = new DateTimeOffset(expiresAt),
            IsEssential = true
        });

        return Ok(new
        {
            message = "Signed in.",
            accessToken
        });
    }

    private string CreateAccessToken(UserAccount user, DateTime expiresAt)
    {
        var issuer = configuration["Jwt:Issuer"]!;
        var audience = configuration["Jwt:Audience"]!;
        var signingKey = configuration["Jwt:SigningKey"]!;
        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, user.Id),
            new Claim(JwtRegisteredClaimNames.UniqueName, user.UserName!)
        };
        var credentials = new SigningCredentials(
            new SymmetricSecurityKey(Encoding.UTF8.GetBytes(signingKey)),
            SecurityAlgorithms.HmacSha256);

        return new JwtSecurityTokenHandler().WriteToken(new JwtSecurityToken(
            issuer,
            audience,
            claims,
            expires: expiresAt,
            signingCredentials: credentials));
    }
}