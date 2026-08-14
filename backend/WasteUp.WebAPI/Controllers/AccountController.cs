using Google.Apis.Auth;
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
    private static readonly TimeSpan StandardSessionLifetime = TimeSpan.FromHours(8);
    private static readonly TimeSpan RememberedSessionLifetime = TimeSpan.FromDays(30);

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

        return CompleteSignIn(user, request.RememberMe);
    }

    [HttpGet("google/config")]
    public IActionResult GetGoogleConfiguration()
    {
        var clientId = configuration["GoogleOAuth:ClientId"];
        if (string.IsNullOrWhiteSpace(clientId))
        {
            return StatusCode(StatusCodes.Status503ServiceUnavailable, new
            {
                error = "Google sign-in is not configured."
            });
        }

        return Ok(new { clientId });
    }

    [HttpPost("google")]
    public async Task<IActionResult> SignInWithGoogle(GoogleSignInRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.IdToken))
        {
            return BadRequest(new { error = "Google ID token is required." });
        }

        var clientId = configuration["GoogleOAuth:ClientId"];
        if (string.IsNullOrWhiteSpace(clientId))
        {
            return StatusCode(StatusCodes.Status503ServiceUnavailable, new
            {
                error = "Google sign-in is not configured."
            });
        }

        GoogleJsonWebSignature.Payload googleUser;
        try
        {
            googleUser = await GoogleJsonWebSignature.ValidateAsync(
                request.IdToken,
                new GoogleJsonWebSignature.ValidationSettings
                {
                    Audience = [clientId]
                });
        }
        catch (InvalidJwtException)
        {
            return Unauthorized(new { error = "The Google sign-in token is invalid or expired." });
        }

        if (string.IsNullOrWhiteSpace(googleUser.Subject) ||
            string.IsNullOrWhiteSpace(googleUser.Email) ||
            googleUser.EmailVerified != true)
        {
            return Unauthorized(new { error = "A verified Google email address is required." });
        }

        var loginInfo = new UserLoginInfo("Google", googleUser.Subject, "Google");
        var user = await userManager.FindByLoginAsync(loginInfo.LoginProvider, loginInfo.ProviderKey)
            ?? await userManager.FindByEmailAsync(googleUser.Email);

        if (user is null)
        {
            user = new UserAccount
            {
                UserName = googleUser.Email,
                Email = googleUser.Email,
                EmailConfirmed = true
            };
            var createResult = await userManager.CreateAsync(user);
            if (!createResult.Succeeded)
            {
                return Conflict(new
                {
                    errors = createResult.Errors.Select(error => new { error.Code, error.Description })
                });
            }
        }

        var loginResult = await userManager.AddLoginAsync(user, loginInfo);
        if (!loginResult.Succeeded && loginResult.Errors.All(error => error.Code != "LoginAlreadyAssociated"))
        {
            return BadRequest(new
            {
                errors = loginResult.Errors.Select(error => new { error.Code, error.Description })
            });
        }

        return CompleteSignIn(user, request.RememberMe);
    }

    private IActionResult CompleteSignIn(UserAccount user, bool rememberMe)
    {
        var sessionLifetime = rememberMe
            ? RememberedSessionLifetime
            : StandardSessionLifetime;
        var expiresAt = DateTime.UtcNow.Add(sessionLifetime);
        var accessToken = CreateAccessToken(user, expiresAt);
        var cookieOptions = new CookieOptions
        {
            HttpOnly = true,
            Secure = true,
            SameSite = SameSiteMode.Strict,
            IsEssential = true
        };

        if (rememberMe)
        {
            cookieOptions.Expires = new DateTimeOffset(expiresAt);
        }

        Response.Cookies.Append(AuthenticationCookieName, accessToken, cookieOptions);

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