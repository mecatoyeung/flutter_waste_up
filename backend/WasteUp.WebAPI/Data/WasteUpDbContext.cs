using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using WasteUp.WebAPI.Models;

namespace WasteUp.WebAPI.Data;

public class WasteUpDbContext(DbContextOptions<WasteUpDbContext> options) : IdentityDbContext<UserAccount>(options)
{
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }
}